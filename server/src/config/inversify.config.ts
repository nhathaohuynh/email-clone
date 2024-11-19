import { Container } from 'inversify'
import 'reflect-metadata'
import { IBoard } from '~/databases/models/board.model'
import { ICard } from '~/databases/models/card.model'
import { IColumn } from '~/databases/models/column.model'
import { IComment } from '~/databases/models/comment'
import { IInvitation } from '~/databases/models/invitation.model'
import { IUser } from '~/databases/models/user.model'
import { BoardController } from '~/http/controllers/board.controller'
import { CardController } from '~/http/controllers/card.controller'
import { ColumnController } from '~/http/controllers/column.controller'
import { CommentController } from '~/http/controllers/comment.controller'
import { InvitationController } from '~/http/controllers/invatation.controller'
import { UserController } from '~/http/controllers/user.controller'
import { IRepository } from '~/interface/IRepository'
import { BoardRepository } from '~/repositories/board.repository'
import { CardRepository } from '~/repositories/card.repository'
import { ColumnRepository } from '~/repositories/column.repository'
import { CommentRepository } from '~/repositories/comment.repository'
import { InvitationRepository } from '~/repositories/invitation.repository'
import { UserRepository } from '~/repositories/user.repository'
import { BoardService } from '~/services/board.service'
import { CardService } from '~/services/card.service'
import { ColumnService } from '~/services/column.service'
import { CommentService } from '~/services/comment.service'
import { InvitationService } from '~/services/invitation.service'
import { UserService } from '~/services/user.service'
import { NAME_SERVICE_INJECTION } from '~/utils/constant.util'

const container = new Container()

container.bind<IRepository<IBoard>>(NAME_SERVICE_INJECTION.BOARD_REPOSITORY).to(BoardRepository)
container.bind(BoardService).to(BoardService)
container.bind(BoardController).to(BoardController)

container.bind<IRepository<IColumn>>(NAME_SERVICE_INJECTION.COLUMN_REPOSITORY).to(ColumnRepository)
container.bind(ColumnService).to(ColumnService)
container.bind(ColumnController).to(ColumnController)

container.bind<IRepository<ICard>>(NAME_SERVICE_INJECTION.CARD_REPOSITORY).to(CardRepository)
container.bind(CardService).to(CardService)
container.bind(CardController).to(CardController)

container.bind<IRepository<IUser>>(NAME_SERVICE_INJECTION.USER_REPOSITORY).to(UserRepository)
container.bind(UserService).to(UserService)
container.bind(UserController).to(UserController)

container.bind<IRepository<IComment>>(NAME_SERVICE_INJECTION.COMMENT_REPOSITORY).to(CommentRepository)
container.bind(CommentService).to(CommentService)
container.bind(CommentController).to(CommentController)

container.bind<IRepository<IInvitation>>(NAME_SERVICE_INJECTION.INVITATION_REPOSITORY).to(InvitationRepository)
container.bind(InvitationService).to(InvitationService)
container.bind(InvitationController).to(InvitationController)

export { container }
