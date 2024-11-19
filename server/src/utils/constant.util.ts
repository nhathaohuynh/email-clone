export const API_PREFIX = '/api/v1/trello'
export const HOST = 'http://localhost'

export const OBJECT_ID_RULE = /^[0-9a-fA-F]{24}$/

export const OBJECT_ID_RULE_MESSAGE = 'Your string fails to match the Object Id pattern!'

export const WHITELISTED_ORIGINS = ['http://localhost:5173']

export const BOARD_TYPES = {
  PUBLIC: 'public',
  PRIVATE: 'private'
}

export const INVALID_UPDATE_FIELDS = ['_id', 'createdAt']

export const NAME_SERVICE_INJECTION = {
  USER_REPOSITORY: 'UserRepository'
}

export const TEMPLATE_EMAIL_VERIFY_EMAIL = `<!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
              body {
                  font-family: Arial, sans-serif;
                  background-color: #f4f4f4;
                  margin: 0;
                  padding: 0;
              }
              .email-container {
                  max-width: 600px;
                  margin: 50px auto;
                  background-color: #fff;
                  padding: 20px;
                  border-radius: 8px;
                  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
              }
              .email-header {
                  text-align: center;
                  padding-bottom: 20px;
                  border-bottom: 1px solid #ddd;
              }
              .email-header h1 {
                  margin: 0;
                  color: #333;
              }
              .email-body {
                  padding: 20px;
              }
              .email-body p {
                  color: #555;
                  line-height: 1.6;
              }
              .verify-button {
                  display: block;
                  width: 200px;
                  margin: 20px auto;
                  padding: 10px 20px;
                  text-align: center;
                  background-color: #007bff;
                  color: #fff !important;
                  text-decoration: none;
                  border-radius: 4px;
              }
              .verify-button:hover {
                  background-color: #0056b3;
              }
          </style>
      </head>
      <body>
          <div class="email-container">
              <div class="email-header">
                  <h1>Verification Your Account</h1>
              </div>
              <div class="email-body">
                  <p>Thank you for registering with us. Please click the button below to verify your email address to complete the registration process.</p>
                  <a href="{{link_verify}}" class="verify-button">Click here</a>
                  <p>If you did not create an account, no further action is required.</p>
                  <p>Best regards,</p>
                  <p>&copy; 2024. All rights reserved.</p>
                  <p>Contact with us: <a href="mailto:huynhnhathao0609@gmail.com">huynhnhathao0609@gmail.com</a></p>
              </div>
          </div>
      </body>
      </html>
`

export const LITMIT_COMMON_FILE_SIZE = 1024 * 1024 * 10 // 10MB

export const ALLOW_FILE_TYPE = ['image/png', 'image/jpg', 'image/jpeg']

export const DEFAULT_PAGE = 1

export const DEFAULT_ITEM__PER_PAGE = 12

export const DEFAULT_AVATAR =
  'https://res.cloudinary.com/dk9v8v1lp/image/upload/v1626820734/trello/avatars/default-avatar.png'

export const WINDOW_SIZE_IN_SECONDS = 60
export const MAX_REQUESTS = 1000
