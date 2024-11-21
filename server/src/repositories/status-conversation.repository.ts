import { injectable } from 'inversify'
import { BaseRepository } from './repository.abstract'
import { IStatusConversation, StatusConversationModel } from '~/databases/models/conversation-status.model'
import { UpdateQuery } from 'mongoose'
import { DOCUMENT_MODLE_REGISTRATION } from '~/utils/constant.util'

@injectable()
export class StatusConversationRepository extends BaseRepository<IStatusConversation> {
  constructor() {
    super(StatusConversationModel)
  }

  async getListConversation(query: Record<string, boolean | string | object>) {
    return this.model
      .find(query)
      .populate({
        path: 'conversation',
        model: DOCUMENT_MODLE_REGISTRATION.CONVERSATION,
        populate: {
          path: 'messages',
          model: DOCUMENT_MODLE_REGISTRATION.MESSAGE
        }
      })
      .populate('draft_message')
  }

  async findByMailAddressAndUpdate(
    filter: { mail_address: string; draft_message: string },
    payload: UpdateQuery<IStatusConversation>
  ) {
    return this.model.findOneAndUpdate(
      {
        ...filter,
        draft_status: true
      },
      payload,
      { new: true }
    )
  }
}
