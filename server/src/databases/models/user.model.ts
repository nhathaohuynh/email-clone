import mongoose, { Document, ObjectId, Schema } from 'mongoose'
import { DEFAULT_AVATAR } from '~/utils/constant.util'

export const USER_COLLECTION = 'Users'
export const USER_DOCUMENT_NAME = 'user'
export const USER_NOT_EXPOSE_FIELDS = ['password', 'verifyToken', 'expired']

export interface IUser extends Document {
  _id: ObjectId
  email: string
  password: string
  full_name: string
  avatar: string
  phone: string
  two_step_verification: boolean
  expired: Date
  token: string
}

export const USER_SELECT_FIELDS = ['_id', 'email', 'username', 'avatar', 'phone']

const UserSchema: Schema = new Schema<IUser>(
  {
    email: {
      type: String,
      required: true,
      trim: true,
      unique: true,
      index: true,
      match: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/,
      validate: {
        validator: function (email: string) {
          return /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/.test(email)
        },
        message: 'Invalid email address'
      }
    },

    password: {
      type: String,
      required: true,
      minlength: 8,
      trim: true
    },

    full_name: {
      type: String,
      required: true,
      trim: true
    },

    avatar: {
      type: String,
      trim: true,
      default: DEFAULT_AVATAR
    },

    phone: {
      type: String,
      trim: true,
      required: true,
      match: /^[0-9]{10}$/
    },

    two_step_verification: {
      type: Boolean,
      default: false
    },

    expired: {
      type: Date,
      default: null
    },

    token: {
      type: String,
      required: true
    }
  },
  {
    timestamps: true,
    collection: USER_COLLECTION
  }
)

export const UserModel = mongoose.model<IUser>(USER_DOCUMENT_NAME, UserSchema)
