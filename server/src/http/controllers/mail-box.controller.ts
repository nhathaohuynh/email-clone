import { Request, Response } from 'express'
import { inject, injectable } from 'inversify'
import { MailBoxService } from '~/services/mail-box.service'
import { CreatedResponse, OKResponse } from '~/utils/success-response.util'

const MESSAGES = {
  COMPOSE_SUCCESS: 'Compose email successfully',
  SEND_SUCCESS: 'Send email successfully'
}

@injectable()
export class MailBoxController {
  constructor(@inject(MailBoxService) private mailBoxService: MailBoxService) {}

  async composeMessage(req: Request, res: Response) {
    const data = await this.mailBoxService.composeMail(req.mail_address, req.body)
    return new CreatedResponse(data, MESSAGES.SEND_SUCCESS).send(req, res)
  }

  async sednMessage(req: Request, res: Response) {
    const data = await this.mailBoxService.sendMessage(req.mail_address, req.body)
    return new CreatedResponse(data, MESSAGES.COMPOSE_SUCCESS).send(req, res)
  }

  async getListConversationByStatus(req: Request, res: Response) {
    const { label } = req.query
    const data = await this.mailBoxService.getListConversation(req.mail_address, label as string)
    return new OKResponse(data).send(req, res)
  }
}
