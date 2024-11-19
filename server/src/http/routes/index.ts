import express from 'express'
import { ROUTE_APP } from './route-config-app'
import { RouteUser } from './user.route'
const router = express.Router()

// user API

router.use(ROUTE_APP.users.path, RouteUser)

export default router
