import { inject, injectable } from 'inversify'
import { IMessage } from '~/databases/models/message.model'
import { MessageRepository } from '~/repositories/message.repository'
import { NAME_SERVICE_INJECTION } from '~/utils/constant.util'

@injectable()
export class MessageService {
  constructor(
    @inject(NAME_SERVICE_INJECTION.MESSAGE_REPOSITORY) private readonly messageRepository: MessageRepository
  ) {}

  async create(payload: Partial<IMessage>) {
    return this.messageRepository.create(payload)
  }

  async updateMessageById(id: string, payload: Partial<IMessage>) {
    console.log()
    return this.messageRepository.findByIdAndUpdate(id, {
      $set: payload
    })
  }
}
