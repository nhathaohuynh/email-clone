import mongoose, { Document, Schema } from 'mongoose'
import { DOCUMENT_MODLE_REGISTRATION } from '~/utils/constant.util'

export const CONVERSATION_COLLECTION = 'conversations'

export interface IConversation extends Document {
  _id: Schema.Types.ObjectId
  subject: string
  participants: string[]
  has_attachments: boolean
  last_message_date: Date
  slug: string
  messages: Schema.Types.ObjectId[]
}

export const conversationSchema = new Schema<IConversation>(
  {
    subject: {
      type: String,
      required: true,
      trim: true
    },

    has_attachments: {
      type: Boolean,
      default: false
    },

    last_message_date: {
      type: Date,
      default: Date.now()
    },

    participants: {
      type: [String],
      required: true
    },

    slug: {
      type: String,
      required: true,
      trim: true
    },

    messages: {
      type: [{ type: Schema.Types.ObjectId, ref: DOCUMENT_MODLE_REGISTRATION.MESSAGE }],
      required: true
    }
  },
  { timestamps: true, collection: CONVERSATION_COLLECTION }
)

export const ConversationModel = mongoose.model<IConversation>(
  DOCUMENT_MODLE_REGISTRATION.CONVERSATION,
  conversationSchema
)
