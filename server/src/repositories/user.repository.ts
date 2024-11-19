import { injectable } from 'inversify'
import { IUser, UserModel } from '~/databases/models/user.model'
import { BaseRepository } from './repository.abstract'

@injectable()
export class UserRepository extends BaseRepository<IUser> {
  constructor() {
    super(UserModel)
  }

  findByEmail(email: string) {
    return this.findOne({ email })
  }
}
