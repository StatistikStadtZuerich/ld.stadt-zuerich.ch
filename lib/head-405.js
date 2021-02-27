const { MethodNotAllowed } = require('http-errors')

function factory (router) {
  router.use((req, res, next) => {
    if (req.method === 'HEAD') {
      return next(new MethodNotAllowed())
    }

    next()
  })
}

module.exports = factory
