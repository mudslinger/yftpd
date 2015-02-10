
parseString = require('xml2js')
  .parseString

module.exports = class DeliousMaster
  client = require 'cheerio-httpcli'
  logininfo:
    user: 'yamaokaya2'
    pass: 'ajikoime'

  dataformat:
    target: 12
    format: 1
  data = null

  load: (callback)->
    @callback = callback
    @client.fetch 'https://delious.jp/menu/login.php',@logininfo
      .then @loggedin
      .then @downpage
      .then @dataget
      .done ->
        callback(@data)

  loggedin: (result)->
    console.log 'logged in'
    res = result.response
    console.log res.cookies
    return @client.fetch 'https://delious.jp/mainte/m_download.php',AspHelpMenuID: 990100005

  downpage: (result)->
    return @client.fetch 'https://delious.jp/mainte/m_download_csv.php',dataformat

  dataget: (result)->
    xml = result.body
    #console.log xml
    parseString xml, (err,result)->
      console.log err if err
      @data = result.table.row