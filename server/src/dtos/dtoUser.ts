import { IsEmail, IsNotEmpty, IsOptional, IsString, MaxLength, MinLength } from 'class-validator'

export class UserRegistration {
  @IsString()
  @IsNotEmpty()
  @MinLength(3)
  @MaxLength(50)
  username: string

  @IsString()
  @IsNotEmpty()
  @IsEmail()
  email: string

  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  @MinLength(8)
  password: string
}

export class UserLogin {
  @IsString()
  @IsNotEmpty()
  email: string

  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  @MinLength(8)
  password: string
}

export class VerifyToken {
  @IsString()
  @IsNotEmpty()
  token: string
  email: string
}

export class UpdateInformation {
  @IsString()
  @IsOptional()
  @IsNotEmpty()
  @MinLength(3)
  @MaxLength(50)
  username: string

  @IsString()
  @IsOptional()
  @IsNotEmpty()
  phone: string

  @IsString()
  @IsOptional()
  @IsNotEmpty()
  address: string
}

export class UpdatePassword {
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  @MinLength(8)
  password: string

  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  @MinLength(8)
  newPassword: string
}
