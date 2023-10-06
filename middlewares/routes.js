async function bcp(req, res, next) {
    try {
      req.docType = "bcp";
      req.idName = "bcpId";
      next();
    } catch (err) {
      return res.status(500)(res.json({ errors: "Something went wrong" }));
    }
}

async function esp(req, res, next) {
    try {
        req.docType = "esp";
        req.idName = "espId";
        next();
      } catch (err) {
        return res.status(500)(res.json({ errors: "Something went wrong" }));
      }
}

async function broker(req, res, next) {
    try {
        req.docType = "broker";
        req.idName = "brokerId";
        next();
    } catch (err) {
        return res.status(500)(res.json({ errors: "Something went wrong" }));
    }
}

async function osqo(req, res, next) {
    try {
        req.docType = "osqo";
        req.idName = "osqoId";
        next();
    } catch (err) {
        return res.status(500)(res.json({ errors: "Something went wrong" }));
    }
}

module.exports  = {bcp, esp, broker, osqo};
