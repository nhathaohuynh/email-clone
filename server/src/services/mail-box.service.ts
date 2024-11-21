import { StatusConversationService } from '~/services/status-conversation.service'
import { inject, injectable } from 'inversify'
import { ObjectId } from 'mongoose'
import { ComposeMessage, SendMessage } from '~/dtos/mail-box.dto'
import { MailBoxRepository } from '~/repositories/mail-box'
import { MAIL_ADDRESS_RULE, NAME_SERVICE_INJECTION } from '~/utils/constant.util'
import { MessageService } from './message.service'
import { BadRequest } from '~/utils/error-response.util'
import { IMessage } from '~/databases/models/message.model'
import { IConversation } from '~/databases/models/conversation.model'
import { slugify } from '~/utils'
import { ConversationService } from './conversation.service'
import { IStatusConversation } from '~/databases/models/conversation-status.model'

const MESSAGES = {
  MESSAGE_NOT_FOUND: 'Message not found',
  PROVIDE_RECIPIENT: 'Please provide at least one recipient',
  CONVERSATION_CREATE_FAILED: 'Failed to create conversation',
  INVALID_MAIL_ADDRESS: 'Invalid mail address'
}

@injectable()
export class MailBoxService {
  constructor(
    @inject(NAME_SERVICE_INJECTION.MAIL_BOX_REPOSITORY) private readonly repository: MailBoxRepository,
    @inject(MessageService) private readonly messageService: MessageService,
    @inject(StatusConversationService) private readonly statusConversationService: StatusConversationService,
    @inject(ConversationService) private readonly conversation: ConversationService
  ) {}

  async create(mail_address: string, user: ObjectId) {
    return this.repository.create({ mail_address, user })
  }

  findByUser(user: string) {
    return this.repository.findByUser(user)
  }

  async composeMail(mail_address: string, payload: ComposeMessage) {
    const message = await this.messageService.create({
      ...payload,
      from: mail_address
    })
    const statusConversation = await this.statusConversationService.create({
      mail_address: mail_address,
      draft_status: true,
      read_status: true,
      draft_message: message._id
    })

    return statusConversation
  }

  async sendMessage(mail_address: string, payload: SendMessage) {
    if (!payload.to && !payload.cc && !payload.bcc) {
      throw new BadRequest(MESSAGES.PROVIDE_RECIPIENT)
    }

    const validMailAddress = [...payload.to, ...payload.cc, ...payload.bcc].every((email) => {
      return MAIL_ADDRESS_RULE.test(email)
    })
    if (!validMailAddress) {
      throw new BadRequest(MESSAGES.INVALID_MAIL_ADDRESS)
    }

    // update message from draft to sent
    const payloadMessage: Partial<IMessage> = {
      subject: payload?.subject,
      body: payload?.body,
      to: payload?.to.length > 0 ? payload.to : [],
      cc: payload?.cc.length > 0 ? payload.cc : [],
      bcc: payload?.bcc.length > 0 ? payload.bcc : [],
      attachments: payload?.attachments ? payload.attachments : [],
      reply_to: payload?.reply_to ? payload.reply_to : null,
      from: mail_address
    }
    const message = await this.messageService.updateMessageById(payload._id.toString(), payloadMessage)
    if (!message) {
      throw new BadRequest(MESSAGES.MESSAGE_NOT_FOUND)
    }

    // create conversation
    const dataConversation: Partial<IConversation> = {
      subject: message.subject,
      participants: [mail_address, ...message.to, ...message.cc, ...message.bcc],
      has_attachments: !!message.attachments.length,
      last_message_date: new Date(Date.now()),
      slug: slugify(message.subject),
      messages: [message._id]
    }

    const conversation = await this.conversation.create(dataConversation)
    if (!conversation) {
      throw new BadRequest(MESSAGES.CONVERSATION_CREATE_FAILED)
    }

    // update  sender status conversation and create status conversation for participants
    const updateDataStatusConversation: Partial<IStatusConversation> = {
      conversation: conversation._id,
      draft_message: null,
      sent_at: new Date(Date.now()),
      draft_status: false,
      sent_status: true,
      read_status: true
    }

    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const [resConversation, ..._] = await Promise.all([
      this.statusConversationService.updateStatusConversation(
        { mail_address, draft_message: message._id.toString() },
        updateDataStatusConversation
      ),
      ...conversation.participants.map(async (participant) => {
        if (participant !== mail_address) {
          await this.statusConversationService.create({
            mail_address: participant,
            conversation: conversation._id,
            inbox_status: true,
            read_status: false
          })
        }
      })
    ])

    return resConversation
  }

  async getListConversation(mail_address: string, label: string) {
    return this.statusConversationService.getListConversation(mail_address, label)
  }
}
