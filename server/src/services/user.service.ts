/* eslint-disable @typescript-eslint/no-unused-vars */
import bcrypt from 'bcryptjs'
import { inject, injectable } from 'inversify'
import env from '~/config/env.config'
import { USER_SELECT_FIELDS } from '~/databases/models/user.model'
import { UpdateInformation, UpdatePassword, UserLogin, UserRegistration, VerifyToken } from '~/dtos/dtoUser'
import { UserRepository } from '~/repositories/user.repository'
import { NAME_SERVICE_INJECTION, TEMPLATE_EMAIL_VERIFY_EMAIL } from '~/utils/constant.util'

import { BadRequest, ConflictError, ForbiddenError, NotAcceptable, NotFoundError } from '~/utils/error-response.util'

import { EmailOptions } from '~/types'
import { generateToken, replacePlaceholder, selectedFields, verifyToken } from '~/utils'
import emailService from './email.service'

const CONSTANT = {
  MSG_USER_EXIST: 'User already exists',
  MSG_CREATE_USER_FAILED: 'Failed to sign up a user',
  MSG_USER_NOT_FOUND: 'user not found',
  MSG_UPDATE_USER_FAILED: 'Failed to update user',
  MSG_DELETE_USER_FAILED: 'Failed to delete user',
  EMAIL_SUBJECT: 'Verify your email address',
  MSG_INVALID_TOKEN: 'Invalid token',
  MSG_NOT_ACCEPTABLE: 'User already verified',
  MSG_USER_LOGIN_FAILED: 'Email or password is incorrect',
  MSG_PASSWORD_NOT_MATCH: 'Password is not match',
  MSG_PASSWORD_SAME: 'New password must be different from old password'
}

@injectable()
export class UserService {
  constructor(@inject(NAME_SERVICE_INJECTION.USER_REPOSITORY) private readonly userRepository: UserRepository) {}

  async signUp(body: UserRegistration) {
    const existingUsser = await this.userRepository.findByEmail(body.email)

    if (existingUsser) {
      throw new ConflictError(CONSTANT.MSG_USER_EXIST)
    }

    const hashPassword = bcrypt.hashSync(body.password)
    const verifyToken = crypto.randomUUID()
    const user = await this.userRepository.create({ ...body, password: hashPassword, verifyToken })

    const linkVerify = `${env.CLIENT_URL}/verify?email=${body.email}&token=${verifyToken}`

    const emailOptions: EmailOptions = {
      email: body.email,
      subject: CONSTANT.EMAIL_SUBJECT,
      html: replacePlaceholder(TEMPLATE_EMAIL_VERIFY_EMAIL, { link_verify: linkVerify })
    }

    emailService.sendSingleMail(emailOptions)

    return user?._id
  }

  async signIn(body: UserLogin) {
    const user = await this.userRepository.findByEmail(body.email)

    if (!user) {
      throw new NotFoundError(CONSTANT.MSG_USER_NOT_FOUND)
    }

    const isMatchPassword = bcrypt.compareSync(body.password, user.password)

    if (!isMatchPassword) {
      throw new BadRequest(CONSTANT.MSG_USER_LOGIN_FAILED)
    }

    const accessToken = generateToken({ id: user._id }, env.AT_JWT_SECRET, env.AT_EXPIRES_IN)
    const refreshToken = generateToken({ id: user._id }, env.RT_JWT_SECRET, env.RT_EXPIRES_IN)

    const userRes = selectedFields(USER_SELECT_FIELDS, user)
    return {
      user: userRes,
      accessToken,
      refreshToken
    }
  }

  async verifyByEmail(body: VerifyToken) {
    const user = await this.userRepository.findByEmail(body.email)

    if (!user) {
      throw new NotFoundError(CONSTANT.MSG_USER_NOT_FOUND)
    }

    const isMatchToken = user.verifyToken === body.token
    if (!isMatchToken) {
      throw new BadRequest(CONSTANT.MSG_INVALID_TOKEN)
    }

    if (user.isActive) {
      throw new NotAcceptable(CONSTANT.MSG_NOT_ACCEPTABLE)
    }

    const res = await this.userRepository.findByIdAndUpdate(user._id.toString(), {
      $set: { isActive: true, verifyToken: null }
    })

    if (!res) {
      throw new BadRequest(CONSTANT.MSG_UPDATE_USER_FAILED)
    }
    return {
      _id: res._id
    }
  }

  async refreshToken(oldRefreshToken: string) {
    try {
      const user = verifyToken(oldRefreshToken, env.RT_JWT_SECRET)

      if (!user) {
        throw new ForbiddenError()
      }

      const accessToken = generateToken({ id: user.id }, env.AT_JWT_SECRET, env.AT_EXPIRES_IN)
      const refreshToken = generateToken({ id: user.id }, env.RT_JWT_SECRET, env.RT_EXPIRES_IN)

      return {
        user,
        accessToken,
        refreshToken
      }
    } catch (error) {
      throw new ForbiddenError()
    }
  }

  async updateInformation(userId: string, body: UpdateInformation) {
    const user = await this.userRepository.findById(userId)

    if (!user) {
      throw new NotFoundError(CONSTANT.MSG_USER_NOT_FOUND)
    }

    const res = await this.userRepository.findByIdAndUpdate(userId, {
      $set: {
        ...body,
        updatedAt: Date.now()
      }
    })

    if (!res) {
      throw new BadRequest(CONSTANT.MSG_UPDATE_USER_FAILED)
    }

    const userRes = selectedFields(USER_SELECT_FIELDS, res)
    return userRes
  }

  async changePassword(userId: string, body: UpdatePassword) {
    const user = await this.userRepository.findById(userId)

    if (!user) {
      throw new NotFoundError(CONSTANT.MSG_USER_NOT_FOUND)
    }

    if (body.password === body.newPassword) {
      throw new BadRequest(CONSTANT.MSG_PASSWORD_SAME)
    }

    const isMatchPassword = bcrypt.compareSync(body.password, user.password)

    if (!isMatchPassword) {
      throw new BadRequest(CONSTANT.MSG_PASSWORD_NOT_MATCH)
    }

    const hashPassword = bcrypt.hashSync(body.newPassword)

    const res = await this.userRepository.findByIdAndUpdate(userId, { $set: { password: hashPassword } })

    if (!res) {
      throw new BadRequest(CONSTANT.MSG_UPDATE_USER_FAILED)
    }

    return {
      _id: res._id
    }
  }

  async forgotPassword(body: { email: string }) {
    console.log(body)
  }
}
