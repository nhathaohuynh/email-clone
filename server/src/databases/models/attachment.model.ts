import mongoose, { Document, Schema } from 'mongoose'
import { MESSAGE_DOCUMENT_NAME } from './message.model'

export const ATTACHMENT_COLLECTION = 'Attachments'
export const ATTACHMENT_DOCUMENT_NAME = 'Attachment'

export interface IAttachment extends Document {
  _id: Schema.Types.ObjectId
  mimeType: string
  size: number
  email: Schema.Types.ObjectId
  url: string
  url_id: string
  name: string
  slug: string
}

const attachmentchema = new Schema<IAttachment>(
  {
    mimeType: {
      type: String,
      required: true,
      trim: true
    },
    size: {
      type: Number,
      required: true
    },
    email: {
      type: Schema.Types.ObjectId,
      ref: MESSAGE_DOCUMENT_NAME,
      required: true
    },
    url: {
      type: String,
      required: true,
      trim: true
    },
    url_id: {
      type: String,
      required: true,
      trim: true
    },
    name: {
      type: String,
      required: true,
      trim: true
    },
    slug: {
      type: String,
      required: true,
      trim: true
    }
  },
  { timestamps: true, collection: ATTACHMENT_COLLECTION }
)

attachmentchema.index({ mimeType: 1, slug: 1 }, { unique: true })

export const EmailAddress = mongoose.model<IAttachment>(ATTACHMENT_DOCUMENT_NAME, attachmentchema)
