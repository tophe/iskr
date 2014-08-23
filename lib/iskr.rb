require "xmlrpc/client"

# ruby binding for isk v0.9.3
# not all function implemented
# 2012-02-06 cvigny

class Isk
  # Make an object to represent the XML-RPC @server.
  
  #default values
  @@host = "solr1"
  @@path = "/RPC"
  @@port = 31128
  @@db_id = 1
  
  def initialize(db_id=@@db_id,host=@@host, path=@@path, port=@@port, proxy_host=nil, proxy_port=nil, user=nil, password=nil, use_ssl=nil, timeout=nil)
    @db_id = db_id
    @server = XMLRPC::Client.new( host, path,port,proxy_host,proxy_port,user,password,use_ssl,timeout)
  end

  def db_id
    @db_id
  end
  
  # isk mapping
  
  #queryImgID(dbId, id, numres=12, sketch=0, fast=False)
  #	 
  #
  #Return the most similar images to the supplied one. The supplied image must be already indexed, and is referenced by its ID.
  #
  #Parameters:
  #
  #        dbId (number) - Database space id.
  #        id (number) - Target image id.
  #        numres (number) - Number of results to return. The target image is on the result list.
  #        sketch (number) - 0 for photographs, 1 for hand-sketched images or low-resolution vector images.
  #        fast (boolean) - if true, only the average color for each image is considered. Image geometry/features are ignored. Search is faster this way.
  #
  #Returns: array
  #    array of arrays: [[image id 1, score],[image id 2, score],[image id 3, score], ...] (id is Integer, score is Double)   
  def query_img_id(id,numres=12, sketch=0, fast=false)
    if is_img_on_db(id)
      @server.call("queryImgID",db_id,id,numres,sketch,fast)
    else
      puts "not in image database #{id}"
    end
  end
  def query_img_blob(data,numres=12, sketch=0, fast=False)
    @server.call("queryImgBlob",db_id,data,numres,sketch,fast)
  end
  def query_img_path(path,numres=12, sketch=0, fast=False)
    @server.call("queryImgPath",db_id,path,numres,sketch,fast)
  end
  
  def add_img_blob(id,data)
    @server.call("addImgBlob",db_id, id, data)
  end
  
  # add image id et file
  def add_img(id, file)
    @server.call("addImg",db_id,id,file)
  end
  
  def save_db()
    @server.call("saveDb",db_id)
  end

  def save_db_as(filename)
    @server.call("saveDbAs",db_id, filename)
  end 
  
  def load_db(id)
    @server.call("loadDb",db_id, id, data)
  end
  
  def remove_img(id)
    @server.call("removeImg",db_id,id)
  end
  
    
  def reset_db(id)
    @server.call("resetDb",db_id)
  end
  
  def create_db()
    @server.call("createDb",db_id)
  end
  
  def shutdown_server()
    @server.call("shutdownServer")
  end
  
  # img count
  def get_db_img_count
    @server.call("getDbImgCount",db_id)
  end
  
  def is_img_on_db(id)
    @server.call("isImgOnDb",db_id,id)
  end
  
  def get_img_dimensions(id) 
    @server.call("getImgDimensions",db_id,id)
  end
   
  def calc_img_avgl_diff(id1,id2)
    @server.call("calcImgAvglDiff",db_id,id1,id2)
  end
   
  def cacl_img_diff(id1,id2)
    @server.call("calcImgDiff",db_id,id1,id2)
  end
   
  def get_img_avgl(id)
    @server.call("getImgAvgl",db_id,id)
  end

  def get_db_list
    @server.call("getDbList")
  end
  
  
  def get_db_img_id_list
    @server.call("getDbImgIdList",db_id)
  end
  
  def get_db_detailed_list
    @server.call("getDbDetailedList")
  end
    
  def save_all_dbs_as(path)
    @server.call("saveAllDbsAs",path)
  end
    
  def add_keyword_img(id,keyword)
    @server.call("addKeywordImg",db_id,id,keyword)
  end
    
  
  #  getAllImgsByKeywords(dbId, numres, kwJoinType, keywords)
  #	 
  #
  #Return all images with the given keywords
  #
  #Parameters:
  #
  #        dbId (number) - Database space id.
  #        kwJoinType (number) - Logical operator for target keywords: 1 for AND, 0 for OR
  #        keywords (string) - comma separated list of keyword ids. An empty string will return random images.
  #
  #Returns: array
  #    array of image ids   
  
  def get_all_imgs_by_keywords(numres,kwjointype,keywords)
    @server.call("getAllImgsByKeywords",db_id,numres,kwjointype,keywords)
  end
  
  def query_img_id_fast_keywords(id,numers,kwjointype,keywords)
    @server.call("queryImgIDFastKeywords",db_id,id,numres,kwjointype,keywords)
  end
    #  queryImgIDKeywords(dbId, imgId, numres, kwJoinType, keywords)
  #	 
  #
  #Query for similar images considering keywords. The input keywords are used for narrowing the search space.
  #
  #Parameters:
  #
  #        dbId (number) - Database space id.
  #        imgId (number) - Target image id. If '0', random images containing the target keywords will be returned.
  #        numres (number) - Number of results desired
  #        kwJoinType (number) - logical operator for keywords: 1 for AND, 0 for OR
  #        keywords (string) - comma separated list of keyword ids.
  #
  #Returns: array
  #    array of arrays: [[image id 1, score],[image id 2, score],[image id 3, score], ...] (id is Integer, score is Double) 
    
  
  def query_img_id_keywords(id,numers,kwjointype,keywords)
    @server.call("queryImgIDKeywords",db_id,id,numres,kwjointype,keywords)
  end
  
  #mostPopularKeywords(dbId, imgs, excludedKwds, count, mode)
  #	 
  #
  #Returns the most frequent keywords associated with a given set of images
  #
  #Parameters:
  #
  #        imgs (string) - Comma separated list of target image ids
  #        excludedKwds (string) - Comma separated list of keywords ids to be excluded from the frequency count
  #        mode (number) - ignored, will be used on future versions.
  #        dbId (number @param dbId Database space id.)
  #        count (number @param count Number of keyword results desired)
  #
  #Returns: array
  #    array of keyword ids and frequencies: [kwd1_id, kwd1_freq, kwd2_id, kwd2_freq, ...]   
  def most_popular_keywords(imgs,exclude_keywords,count,mode)
    @server.call("mostPopularKeywords",db_id,imgs,exclude_keywords,count,mode)
  end
  
  def get_keywords_img(id)
    @server.call("getKeywordsImg",db_id,id)
  end
  
  def remove_all_keyword_img(id)
    @server.call("removeAllKeywordImg",db_id,id)
  end
  
  #addKeywordsImg(dbId, imgId, hashes)
  #	 
  #
  #Associate keywords to image
  #
  #Parameters:
  #
  #        dbId (number) - Database space id.
  #        imgId (number) - Target image id.
  #        hashes (list of number) - Keyword hashes to associate
  #
  #Returns: boolean
  #    true if image id exists     
  def add_keywords_img(id,hashes)
    @server.call("addKeywordsImg",db_id,id,hashes)
  end
    
  def add_dir(path,recurse)
    @server.call("addDir",db_id,path,recurse)
  end
    
  def load_all_dbs_as(path)
    @server.call("loadAllDbs",path)
  end
    
  def save_all_dbs
    @server.call("saveAllDbs")
  end
  
  def load_all_dbs
    @server.call("loadAllDbs")
    @load_all_dbs = true
  end
    
  def remove_db()
    @server.call("removeDb",db_id)
  end
  
  
  def get_global_server_stats
    @server.call("getGlobalServerStats")
  end
  
  def is_valid_db()
    @server.call("isValidDb",db_id)
  end
  
  def get_isk_log(window=30)
    @server.call("getIskLog",window)
  end
end
