import { IsArray, IsNotEmpty, IsOptional, IsString } from 'class-validator'
import { ObjectId } from 'mongoose'

export class ComposeMessage {
  @IsString()
  @IsNotEmpty()
  @IsOptional()
  subject: string

  @IsString()
  @IsNotEmpty()
  @IsOptional()
  body: string

  @IsArray()
  @IsNotEmpty()
  @IsOptional()
  attachments: ObjectId[]

  @IsArray()
  @IsNotEmpty()
  @IsOptional()
  to: string[]

  @IsArray()
  @IsNotEmpty()
  @IsOptional()
  cc: string[]

  @IsArray()
  @IsNotEmpty()
  @IsOptional()
  bcc: string[]

  @IsString()
  @IsNotEmpty()
  @IsOptional()
  reply_to: ObjectId
}

export class SendMessage {
  @IsString()
  @IsNotEmpty()
  _id: ObjectId

  @IsString()
  @IsNotEmpty()
  subject: string

  @IsString()
  @IsNotEmpty()
  body: string

  @IsArray()
  @IsNotEmpty()
  @IsOptional()
  attachments: ObjectId[]

  @IsArray()
  to: string[]

  @IsArray()
  cc: string[]

  @IsArray()
  bcc: string[]

  @IsString()
  @IsNotEmpty()
  @IsOptional()
  reply_to: ObjectId
}
