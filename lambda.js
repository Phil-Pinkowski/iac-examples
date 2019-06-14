const handler = async () => {
  return {
    statusCode: 200,
    body: JSON.stringify({ hello: process.env.TEST }),
    headers: {},
    isBase64Encoded: false
  };
};

module.exports = { handler };
