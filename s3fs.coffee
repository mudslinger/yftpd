zlib = require 'zlib'
module.exports = class S3fs
  s3: null
  chroot : ''
  constructor: (key,s3)->
    @s3 = s3
    @chroot = key

  filestat: (size,time)->
    isFile: -> true
    isDirectory: -> false
    isBlockDevice: -> false
    isSymbolicLink: -> false
    isFIFO: -> false
    isSocket: -> false
    mode: 4
    size: size
    atime: time
    mtime: time
    ctime: time
  dirstat: ->
    isFile: -> false
    isDirectory: -> true
    isBlockDevice: -> false
    isSymbolicLink: -> false
    isFIFO: -> false
    isSocket: -> false
    mode: 4
    size: 0
    atime: new Date()
    mtime: new Date()
    ctime: new Date()

  pathman: (path)->
    console.log 'chroot:',@chroot
    console.log 'path:',path
    p = null
    if path.indexOf(@chroot) != 0
      p = @chroot + path
    else
      p = path
    p

  pathmand: (path)->
    p = @pathman(path)
    p = p + '/' unless /\/$/.test p
    p

  unlink: (path,callback)->
    path = @pathman(path)
    @s3.deleteObject
      Key: path,
      (err,data)->
        callback err
  rmdir: (path,callback)->
    path = @pathmand(path)
    @s3.deleteObject
      Key: path,
      (err,data)->
        callback err
  readdir: (path, callback)->
    console.log 'readdir:'
    console.log path
    path = @pathmand(path)
    console.log path
    @exists path,(exists)=>
      if exists
        @s3.listObjects
          Prefix: path
          (err,data)->
            if data
              contents = data.Contents
              files = (item.Key.replace(path,'') for item in contents when item.Key != path)
              callback(err,files)
      else
        callback null,[]
  mkdir: (path,permission=777, callback)->
    console.log 'mkdir:'
    path = @pathmand(path)
    console.log 'callback is:',callback
    @exists path,(exists)=>
      unless exists
        @s3.putObject
          Key: path
          Body: null
          (err,data)->
            console.log err
            console.log data
            callback err,data
  writeFile: (path, data, callback)->
    path = @pathman(path)
    @s3.putObject
      ACL: 'public-read'
      Key: path
      Body: data
      ContentType: 'text/csv'
      (err,data)->
        callback err,data
  readFile: (path,callback)->
    path = @pathman(path)
    @exists path,(exists)=>
      if exists
        @s3.getObject
          Key: path
          (err,data)=>
            console.log err
            console.log data
            throw err if err
            if data.ContentEncoding == 'gzip'
              zlib.gunzip data.Body,(err2,bin)=>
                callback err2,bin
            else
              callback err,data.Body
      else
        callback 'not found', null
  rename: (f)->
    0
  stat: (path,callback)->
    console.log 'stat:'
    console.log path
    #TODO FIX
    path = @pathman(path)
    console.log path
    filestat = @filestat
    dirstat = @dirstat
    @folder_exists path,(exists)=>
      if exists
        callback false,dirstat()
      else
        @file_exists path,(exists)=>
          if exists
            @s3.headObject
              Key: path
              (err,data)->
                if data
                  console.log data
                  callback false, filestat(data.ContentLength,data.LastModified)
                else
                  callback 'not found', false

  exists: (path,callback)->
    path = @pathman(path)
    console.log 'exists:'
    console.log path
    @s3.headObject
      Key: path
      (err,data)=>
        callback true if data
        #ファイルがなければフォルダを探す
        @folder_exists path,callback if err
  file_exists:  (path,callback)->
    path = @pathman(path)
    @s3.headObject
      Key: path
      (err,data)->
        callback true if data
        callback false if err
  folder_exists: (path,callback)->
    path = @pathmand(path)
    @s3.headObject
      Key: path
      (err,data)->
        callback true if data
        callback false if err