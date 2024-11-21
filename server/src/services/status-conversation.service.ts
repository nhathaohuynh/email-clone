import { inject, injectable } from 'inversify'
import { IStatusConversation } from '~/databases/models/conversation-status.model'
import { StatusConversationRepository } from '~/repositories/status-conversation.repository'
import { DOCUMENT_MODLE_REGISTRATION, NAME_SERVICE_INJECTION } from '~/utils/constant.util'

@injectable()
export class StatusConversationService {
  constructor(
    @inject(NAME_SERVICE_INJECTION.STATUS_CONVERSATION_REPOSITORY)
    private readonly repository: StatusConversationRepository
  ) {}

  async create(payload: Partial<IStatusConversation>) {
    return (await this.repository.create(payload)).populate({
      path: 'draft_message',
      model: DOCUMENT_MODLE_REGISTRATION.MESSAGE
    })
  }

  async getListConversation(mail_address: string, label: string) {
    const query: Record<string, boolean | string | object> = { mail_address }

    switch (label.toLowerCase()) {
      case 'inbox':
        query.inbox_status = true
        break
      case 'sent':
        query.sent_status = true
        break
      case 'starred':
        query.starred_status = true
        break
      case 'trash':
        query.trash_status = true
        break
      case 'draft':
        query.draft_status = true
        break
      default:
        query.label = {
          $in: [label]
        }
        break
    }

    return this.repository.getListConversation(query)
  }

  async updateStatusConversation(
    filter: { mail_address: string; draft_message: string },
    payload: Partial<IStatusConversation>
  ) {
    return this.repository.findByMailAddressAndUpdate(filter, {
      $set: payload
    })
  }
}
