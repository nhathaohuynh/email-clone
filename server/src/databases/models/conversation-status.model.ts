import { Document, Schema, Types, model } from 'mongoose'
import { CONVERSATION_DOCUMENT_NAME } from './conversation.model'
import { LABEL_DOCUMENT_NAME } from './label.model'

export const STATUS_CONVERSATION_COLLECTION = 'StatusConversations'
export const STATUS_CONVERSATION_DOCUMENT_NAME = 'StatusConversation'

interface IStatusConversation extends Document {
  conversationId: Types.ObjectId
  inboxStatus: boolean
  sentStatus: boolean
  draftStatus: boolean
  starredStatus: boolean
  trashStatus: boolean
  labels: Schema.Types.ObjectId[]
  isRead: boolean
}

const statusConversationSchema = new Schema<IStatusConversation>(
  {
    conversationId: {
      type: Schema.Types.ObjectId,
      ref: CONVERSATION_DOCUMENT_NAME,
      required: true
    },

    inboxStatus: {
      type: Boolean,
      default: false
    },

    sentStatus: {
      type: Boolean,
      default: false
    },

    draftStatus: {
      type: Boolean,
      default: false
    },

    starredStatus: {
      type: Boolean,
      default: false
    },

    trashStatus: {
      type: Boolean,
      default: false
    },

    labels: {
      type: [
        {
          type: Schema.Types.ObjectId,
          ref: LABEL_DOCUMENT_NAME
        }
      ],
      default: []
    },

    isRead: {
      type: Boolean,
      default: false
    }
  },
  {
    timestamps: true,
    collection: STATUS_CONVERSATION_COLLECTION
  }
)

export const StatusConversationModel = model<IStatusConversation>(
  STATUS_CONVERSATION_COLLECTION,
  statusConversationSchema
)
