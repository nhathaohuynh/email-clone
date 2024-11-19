import mongoose, { Document, Schema } from 'mongoose'

export const LABEL_COLLECTION = 'Labels'
export const LABEL_DOCUMENT_NAME = 'Label'

export interface ILabel extends Document {
  _id: Schema.Types.ObjectId
  name: string
  color?: string
  description: string
}

export const labelSchema = new Schema<ILabel>(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },

    color: {
      type: String,
      trim: true,
      default: null
    },

    description: {
      type: String,
      trim: true
    }
  },
  { timestamps: true, collection: LABEL_COLLECTION }
)

export const LabelModel = mongoose.model<ILabel>(LABEL_DOCUMENT_NAME, labelSchema)
