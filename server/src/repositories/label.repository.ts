import { injectable } from 'inversify'
import { BaseRepository } from './repository.abstract'
import { ILabel, LabelModel } from '~/databases/models/label.model'

@injectable()
export class LabelRepository extends BaseRepository<ILabel> {
  constructor() {
    super(LabelModel)
  }
}
