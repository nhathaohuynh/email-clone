import { API_PREFIX } from '~/utils/constant.util'

export const ROUTE_APP = {
  users: {
    path: '/users',
    child: {
      signIn: {
        path: '/sign-in',
        method: 'POST'
      },

      twoStepVerification: {
        path: '/two-step-verification',
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

      recoveryPassword: {
        path: '/recovery-password',
        method: 'POST'
      }
    }
  },

  attchments: {
    path: '/attachments',
    child: {
      upload: {
        path: '/',
        method: 'POST'
      },

      delete: {
        path: '/:id',
        method: 'DELETE'
      }
    }
  },

  labels: {
    path: '/labels',
    child: {
      create: {
        path: '/',
        method: 'POST'
      },
      update: {
        path: '/:id',
        method: 'PUT'
      },
      delete: {
        path: '/:id',
        method: 'DELETE'
      }
    }
  },

  mailBox: {
    path: '/mail-box',
    child: {
      compose: {
        path: '/compose',
        method: 'POST'
      },

      getListConversation: {
        path: '/',
        method: 'GET'
      },

      send: {
        path: '/send',
        method: 'POST'
      }
    }
  }
}

export const nameStrateryValidation = {
  // env
  ENV_STRATEGY: 'ENV_STRATEGY',

  // user
  SIGNIN: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.signIn.path}:${ROUTE_APP.users.child.signIn.method}`,
  SIGNUP: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.signUp.path}:${ROUTE_APP.users.child.signUp.method}`,
  VERIFY_TOKEN: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.twoStepVerification.path}:${ROUTE_APP.users.child.twoStepVerification.method}`,
  UPDATE_PASSWORD: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.updatePassword.path}:${ROUTE_APP.users.child.updatePassword.method}`,
  UPDATE_INFORMATION: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.updateInformation.path}:${ROUTE_APP.users.child.updateInformation.method}`,
  RECOVERY_PASSWORD: `${API_PREFIX}${ROUTE_APP.users.path}${ROUTE_APP.users.child.recoveryPassword.path}:${ROUTE_APP.users.child.recoveryPassword.method}`,

  // ATTACHMENTS
  UPLOAD_ATTACHMENT: `${API_PREFIX}${ROUTE_APP.attchments.path}${ROUTE_APP.attchments.child.upload.path}:${ROUTE_APP.attchments.child.upload.method}`,
  DELETE_ATTACHMENT: `${API_PREFIX}${ROUTE_APP.attchments.path}${ROUTE_APP.attchments.child.delete.path}:${ROUTE_APP.attchments.child.delete.method}`,
  // LABELS
  CREATE_LABEL: `${API_PREFIX}${ROUTE_APP.labels.path}${ROUTE_APP.labels.child.create.path}:${ROUTE_APP.labels.child.create.method}`,
  UPDATE_LABEL: `${API_PREFIX}${ROUTE_APP.labels.path}${ROUTE_APP.labels.child.update.path}:${ROUTE_APP.labels.child.update.method}`,
  DELETE_LABEL: `${API_PREFIX}${ROUTE_APP.labels.path}${ROUTE_APP.labels.child.delete.path}:${ROUTE_APP.labels.child.delete.method}`,

  // MAIL BOX
  COMPOSE_MAIL: `${API_PREFIX}${ROUTE_APP.mailBox.path}${ROUTE_APP.mailBox.child.compose.path}:${ROUTE_APP.mailBox.child.compose.method}`,
  SEND_MAIL: `${API_PREFIX}${ROUTE_APP.mailBox.path}${ROUTE_APP.mailBox.child.send.path}:${ROUTE_APP.mailBox.child.send.method}`
}
