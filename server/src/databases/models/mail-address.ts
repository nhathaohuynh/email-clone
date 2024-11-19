import mongoose, { Document, Schema } from 'mongoose'
import { LABEL_DOCUMENT_NAME } from './label.model'
import { MESSAGE_DOCUMENT_NAME } from './message.model'
import { USER_DOCUMENT_NAME } from './user.model'

export const EMAIL_ADDRESS_COLLECTION = 'Emaill_Addresses'
export const EMAIL_ADDRESS_DOCUMENT_NAME = 'Email_Address'

export interface IEmailAddress extends Document {
  _id: Schema.Types.ObjectId
  user: Schema.Types.ObjectId
  mail_address: string
  sent_emails: Schema.Types.ObjectId[]
  received_to: Schema.Types.ObjectId[]
  received_cc: Schema.Types.ObjectId[]
  received_bcc: Schema.Types.ObjectId[]
  reply_to_emails: Schema.Types.ObjectId[]
  auto_reply_enabled: boolean
  auto_reply_message: string
  labels: [
    {
      label: Schema.Types.ObjectId
      conversations: Schema.Types.ObjectId[]
    }
  ]
}

const mailAdressSchema = new Schema<IEmailAddress>(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: USER_DOCUMENT_NAME,
      required: true
    },

    mail_address: {
      unique: true,
      index: true,
      type: String,
      required: true,
      minlength: 3,
      maxlength: 256,
      trim: true,
      validate: {
        validator: function (email: string) {
          return /^[a-zA-Z0-9._%+-]+@mvmanh.com/.test(email)
        },
        message: 'Invalid username address'
      }
    },

    sent_emails: {
      type: [{ type: Schema.Types.ObjectId, ref: MESSAGE_DOCUMENT_NAME }],
      default: []
    },

    received_to: {
      type: [{ type: Schema.Types.ObjectId, ref: MESSAGE_DOCUMENT_NAME }],
      default: []
    },

    received_cc: {
      type: [{ type: Schema.Types.ObjectId, ref: MESSAGE_DOCUMENT_NAME }],
      default: []
    },

    received_bcc: {
      type: [{ type: Schema.Types.ObjectId, ref: MESSAGE_DOCUMENT_NAME }],
      default: []
    },

    reply_to_emails: {
      type: [{ type: Schema.Types.ObjectId, ref: MESSAGE_DOCUMENT_NAME }],
      default: []
    },

    auto_reply_enabled: {
      type: Boolean,
      default: false
    },

    auto_reply_message: {
      type: String,
      default: ''
    },

    labels: [
      {
        label: {
          type: Schema.Types.ObjectId,
          ref: LABEL_DOCUMENT_NAME
        }
      }
    ]
  },
  { timestamps: true, collection: EMAIL_ADDRESS_COLLECTION }
)

mailAdressSchema.index({ user: 1, mail_address: 1 }, { unique: true })

export const EmailAddress = mongoose.model<IEmailAddress>(EMAIL_ADDRESS_DOCUMENT_NAME, mailAdressSchema)
