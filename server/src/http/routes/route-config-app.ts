import { API_PREFIX } from '~/utils/constant.util'

export const ROUTE_APP = {
  users: {
    path: '/users',
    child: {
      signIn: {
        path: '/sign-in',
        method: 'POST'
      },

      verify: {
        path: '/verify',
        method: 'POST'
      },

      signUp: {
        path: '/sign-up',
        method: 'POST'
      },

      refreshToken: {
        path: '/refresh-token',
        method: 'GET'
      },

      logout: {
        path: '/log-out',
        method: 'DELETE'
      },

      updatePassword: {
        path: '/update-password',
        method: 'PUT'
      },

      updateInformation: {
        path: '/update-information',
        method: 'PUT'
      },

      forgotPassword: {
        path: '/forgot-password',
        method: 'POST'
      }
    }
  }
}

export const nameStrateryValidation = {
  ENV_STRATEGY: 'ENV_STRATEGY',
  SIGNIN: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.signIn.path}:${ROUTE_APP.users.child.signIn.method}`,
  SIGNUP: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.signUp.path}:${ROUTE_APP.users.child.signUp.method}`,
  VERIFY_TOKEN: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.verify.path}:${ROUTE_APP.users.child.verify.method}`,
  UPDATE_PASSWORD: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.updatePassword.path}:${ROUTE_APP.users.child.updatePassword.method}`,
  UPDATE_INFORMATION: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.updateInformation.path}:${ROUTE_APP.users.child.updateInformation.method}`,
  FORGOT_PASSWORD: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.forgotPassword.path}:${ROUTE_APP.users.child.forgotPassword.method}`
}
