import { nameStrateryValidation } from '~/http/routes/route-config-app'
import { Constructor } from '~/types'
import { DtoBase } from './dto.base'

import { UpdateInformation, UpdatePassword, UserLogin, UserRegistration, VerifyToken } from './dtoUser'
import { DtoEnv } from './env.dto'

const dtoRegistry: Map<string, Constructor<DtoBase>> = new Map()

dtoRegistry.set(nameStrateryValidation.ENV_STRATEGY, DtoEnv)
dtoRegistry.set(nameStrateryValidation.SIGNUP, UserRegistration)
dtoRegistry.set(nameStrateryValidation.SIGNIN, UserLogin)
dtoRegistry.set(nameStrateryValidation.UPDATE_INFORMATION, UpdateInformation)
dtoRegistry.set(nameStrateryValidation.UPDATE_PASSWORD, UpdatePassword)
dtoRegistry.set(nameStrateryValidation.VERIFY_TOKEN, VerifyToken)

export default dtoRegistry
