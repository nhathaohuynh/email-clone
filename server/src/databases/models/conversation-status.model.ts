import { Document, Schema, model } from 'mongoose'
import { DOCUMENT_MODLE_REGISTRATION } from '~/utils/constant.util'

export const STATUS_CONVERSATION_COLLECTION = 'status_conversations'

export interface IStatusConversation extends Document {
  mail_address: string
  conversation: Schema.Types.ObjectId
  inbox_status: boolean
  draft_message: Schema.Types.ObjectId | null
  sent_at: Date
  draft_status: boolean
  sent_status: boolean
  starred_status: boolean
  trash_status: boolean
  labels: Schema.Types.ObjectId[]
  read_status: boolean
}

const statusConversationSchema = new Schema<IStatusConversation>(
  {
    mail_address: {
      type: String,
      required: true
    },

    sent_at: {
      type: Date,
      default: null
    },

    conversation: {
      type: Schema.Types.ObjectId,
      ref: DOCUMENT_MODLE_REGISTRATION.CONVERSATION,
      default: null
    },

    inbox_status: {
      type: Boolean,
      default: false
    },

    sent_status: {
      type: Boolean,
      default: false
    },

    starred_status: {
      type: Boolean,
      default: false
    },

    draft_message: {
      type: Schema.Types.ObjectId,
      ref: DOCUMENT_MODLE_REGISTRATION.MESSAGE,
      default: null
    },

    draft_status: {
      type: Boolean,
      default: false
    },

    trash_status: {
      type: Boolean,
      default: false
    },

    labels: {
      type: [
        {
          type: Schema.Types.ObjectId,
          ref: DOCUMENT_MODLE_REGISTRATION.LABEL
        }
      ],
      default: []
    },

    read_status: {
      type: Boolean,
      default: false
    }
  },
  {
    timestamps: true,
    collection: STATUS_CONVERSATION_COLLECTION
  }
)

statusConversationSchema.index({ mail_address: 1, inbox_status: 1 })
statusConversationSchema.index({ mail_address: 1, starred_status: 1 })
statusConversationSchema.index({ mail_address: 1, draft_status: 1 })
statusConversationSchema.index({ mail_address: 1, trash_status: 1 })
statusConversationSchema.index({ mail_address: 1, sent_status: 1 })
statusConversationSchema.index({ mail_address: 1, labels: 1 })

export const StatusConversationModel = model<IStatusConversation>(
  DOCUMENT_MODLE_REGISTRATION.STATUS_CONVERSATION,
  statusConversationSchema
)
