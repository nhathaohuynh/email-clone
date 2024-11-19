import mongoose, { Document, Schema } from 'mongoose'
import { EMAIL_ADDRESS_DOCUMENT_NAME } from './mail-address'

export const MESSAGE_COLLECTION = 'Messages'
export const MESSAGE_DOCUMENT_NAME = 'Message'

export interface IMessage extends Document {
  _id: Schema.Types.ObjectId
  sentAt: Date
  subject: string
  body: string
  attachments: Schema.Types.ObjectId[]
  from: Schema.Types.ObjectId[]
  to: Schema.Types.ObjectId[]
  cc: Schema.Types.ObjectId[]
  bcc: Schema.Types.ObjectId[]
  replyTo: Schema.Types.ObjectId[]
}

const messageSchema = new Schema<IMessage>(
  {
    body: {
      type: String,
      required: true,
      trim: true,
      minlength: 1
    },

    sentAt: {
      type: Date,
      default: null
    },

    subject: {
      type: String,
      required: true,
      trim: true
    },

    attachments: {
      type: [{ type: Schema.Types.ObjectId, ref: 'Attachment' }],
      default: []
    },

    from: {
      type: [{ type: Schema.Types.ObjectId, ref: EMAIL_ADDRESS_DOCUMENT_NAME }],
      required: true
    },

    to: {
      type: [{ type: Schema.Types.ObjectId, ref: EMAIL_ADDRESS_DOCUMENT_NAME }],
      default: []
    },

    cc: {
      type: [{ type: Schema.Types.ObjectId, ref: EMAIL_ADDRESS_DOCUMENT_NAME }],
      default: []
    },

    bcc: {
      type: [{ type: Schema.Types.ObjectId, ref: EMAIL_ADDRESS_DOCUMENT_NAME }],
      default: []
    },

    replyTo: {
      type: [{ type: Schema.Types.ObjectId, ref: EMAIL_ADDRESS_DOCUMENT_NAME }],
      default: []
    }
  },
  {
    timestamps: true,
    collection: MESSAGE_COLLECTION
  }
)

export const MessageModel = mongoose.model<IMessage>(MESSAGE_DOCUMENT_NAME, messageSchema)
