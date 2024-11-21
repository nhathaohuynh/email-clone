import { inject, injectable } from 'inversify'
import { IConversation } from '~/databases/models/conversation.model'
import { ConversationRepository } from '~/repositories/conversation.repository'
import { NAME_SERVICE_INJECTION } from '~/utils/constant.util'

@injectable()
export class ConversationService {
  constructor(
    @inject(NAME_SERVICE_INJECTION.CONVERSATION_REPOSITORY) private readonly repository: ConversationRepository
  ) {}

  async create(payload: Partial<IConversation>) {
    return this.repository.create(payload)
  }
}
