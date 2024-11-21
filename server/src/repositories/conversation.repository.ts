import { injectable } from 'inversify'
import { BaseRepository } from './repository.abstract'
import { ConversationModel, IConversation } from '~/databases/models/conversation.model'

@injectable()
export class ConversationRepository extends BaseRepository<IConversation> {
  constructor() {
    super(ConversationModel)
  }
}
