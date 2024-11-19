import { Request, Response } from 'express'
import { inject, injectable } from 'inversify'
import env from '~/config/env.config'
import uploadService from '~/services/upload-image.service'
import { UserService } from '~/services/user.service'
import { CreatedResponse, NoContentResponse, OKResponse } from '~/utils/success-response.util'

const CONSTANT = {
  MSG_CREATE_USER_SUCCESS: 'USer sign up successfully'
}

@injectable()
export class UserController {
  constructor(@inject(UserService) private userService: UserService) {}

  async signUp(req: Request, res: Response) {
    const data = await this.userService.signUp(req.body)
    return new CreatedResponse(data, CONSTANT.MSG_CREATE_USER_SUCCESS).send(req, res)
  }

  async signIn(req: Request, res: Response) {
    const data = await this.userService.signIn(req.body)
    return new OKResponse(data.user).setToken(res, data.accessToken, data.refreshToken).send(req, res)
  }

  async verifyEmail(req: Request, res: Response) {
    const data = await this.userService.verifyByEmail(req.body)
    return new OKResponse(data).send(req, res)
  }

  async logout(req: Request, res: Response) {
    return new OKResponse({ id: req.userId }).clearToken(res).send(req, res)
  }

  async refreshToken(req: Request, res: Response) {
    const data = await this.userService.refreshToken(req.cookies.refreshToken)
    return new OKResponse(data.user).setToken(res, data.accessToken, data.refreshToken).send(req, res)
  }

  async changePassword(req: Request, res: Response) {
    const data = await this.userService.changePassword(req.userId, req.body)
    return new OKResponse(data).send(req, res)
  }

  async updateInformation(req: Request, res: Response) {
    let body = {}
    if (req.file) {
      const url = await uploadService.streamUpload(req.file?.buffer, env.CLOUDINARY_FOLDER)

      body = {
        ...req.body,
        avatar: url?.secure_url
      }
    }

    console.log(body)
    const data = await this.userService.updateInformation(req.userId, {
      ...req.body,
      ...body
    })
    return new OKResponse(data).send(req, res)
  }

  async forgotPassword(req: Request, res: Response) {
    await this.userService.forgotPassword(req.body)
    return new NoContentResponse().send(req, res)
  }
}
