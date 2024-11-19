import mongoose, { Document, Schema } from 'mongoose'
import { MESSAGE_DOCUMENT_NAME } from './message.model'

export const CONVERSATION_COLLECTION = 'Conversations'
export const CONVERSATION_DOCUMENT_NAME = 'Conversation'

export interface IConversation extends Document {
  _id: Schema.Types.ObjectId
  subject: string
  hasAttachments: boolean
  lastMessageDate: Date
  slug: string
  messages: Schema.Types.ObjectId[]
  _destroy: boolean
}

export const conversationSchema = new Schema<IConversation>(
  {
    subject: {
      type: String,
      required: true,
      trim: true
    },

    hasAttachments: {
      type: Boolean,
      default: false
    },

    lastMessageDate: {
      type: Date,
      default: null
    },

    slug: {
      type: String,
      required: true,
      trim: true
    },

    messages: {
      type: [{ type: Schema.Types.ObjectId, ref: MESSAGE_DOCUMENT_NAME }],
      default: []
    },

    _destroy: {
      type: Boolean,
      default: false
    }
  },
  { timestamps: true, collection: CONVERSATION_COLLECTION }
)

export const Conversation = mongoose.model<IConversation>(CONVERSATION_DOCUMENT_NAME, conversationSchema)
