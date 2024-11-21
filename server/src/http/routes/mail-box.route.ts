import express from 'express'
import { container } from '~/config/inversify.config'
import { catchErrorHandler } from '../middlewares/catch-error-handler'
import { validationPipe } from '../middlewares/validationPipe'
import { ROUTE_APP } from './route-config-app'
import { isAuthorized } from '../middlewares/authorized'
import { MailBoxController } from '../controllers/mail-box.controller'

const MailBoxRoute = express.Router()

const mailBoxController = container.get<MailBoxController>(MailBoxController)

MailBoxRoute.route(ROUTE_APP.mailBox.child.compose.path).post(
  isAuthorized,
  validationPipe(),
  catchErrorHandler(mailBoxController.composeMessage.bind(mailBoxController))
)

MailBoxRoute.route(ROUTE_APP.mailBox.child.send.path).post(
  isAuthorized,
  validationPipe(),
  catchErrorHandler(mailBoxController.sednMessage.bind(mailBoxController))
)

MailBoxRoute.route(ROUTE_APP.mailBox.child.getListConversation.path).get(
  isAuthorized,
  validationPipe({ queryParams: ['label'] }),
  catchErrorHandler(mailBoxController.getListConversationByStatus.bind(mailBoxController))
)
export { MailBoxRoute }
