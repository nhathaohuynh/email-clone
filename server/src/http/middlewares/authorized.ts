import { NextFunction, Request, Response } from 'express'
import env from '~/config/env.config'
import { verifyToken } from '~/utils'
import { GoneError, UnauthorizedError } from '~/utils/error-response.util'

export const isAuthorized = (req: Request, res: Response, next: NextFunction) => {
  const accessToken = req.cookies.accessToken
  if (!accessToken) {
    return next(new UnauthorizedError())
  }

  try {
    const decoded = verifyToken(accessToken, env.AT_JWT_SECRET)

    if (!decoded) {
      return next(new UnauthorizedError())
    }

    req.userId = decoded.id

    return next()
  } catch (error) {
    const err = error as Error

    if (err?.message?.includes('jwt expired')) {
      return next(new GoneError('Token expired'))
    }

    return next(new UnauthorizedError('Invalid token'))
  }
}
