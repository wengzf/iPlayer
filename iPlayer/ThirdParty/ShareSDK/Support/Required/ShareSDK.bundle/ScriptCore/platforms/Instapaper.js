var $pluginID = "com.mob.sharesdk.Instapaper";eval(function(p,a,c,k,e,r){e=function(c){return(c<62?'':e(parseInt(c/62)))+((c=c%62)>35?String.fromCharCode(c+29):c.toString(36))};if('0'.replace(0,e)==0){while(c--)r[e(c)]=k[c];k=[function(e){return r[e]||e}];e=function(){return'([3-9a-mo-rt-zA-Z]|[12]\\w)'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('7 m={"I":"1z","J":"1A","X":"covert_url"};8 f(l){3.1B=l;3.i={"r":4,"t":4};3.K=4;3.C="E-F"}f.g.l=8(){k 3.1B};f.g.p=8(){k"f"};f.g.G=8(){6(3.i["t"]!=4&&3.i["t"][m.I]!=4){k 3.i["t"][m.I]}h 6(3.i["r"]!=4&&3.i["r"][m.I]!=4){k 3.i["r"][m.I]}k 4};f.g.R=8(){6(3.i["t"]!=4&&3.i["t"][m.J]!=4){k 3.i["t"][m.J]}h 6(3.i["r"]!=4&&3.i["r"][m.J]!=4){k 3.i["r"][m.J]}k 4};f.g.1f=8(){k"1C-L-"+3.l()+"-"+3.G()};f.g.1g=8(){6(3.i["t"]!=4&&3.i["t"][m.X]!=4){k 3.i["t"][m.X]}h 6(3.i["r"]!=4&&3.i["r"][m.X]!=4){k 3.i["r"][m.X]}k $5.a.1g()};f.g.1D=8(H){6(1E.1F==0){k 3.i["r"]}h{3.i["r"]=3.1h(H)}};f.g.1G=8(H){6(1E.1F==0){k 3.i["t"]}h{3.i["t"]=3.1h(H)}};f.g.saveConfig=8(){7 d=3;7 M="1C-L";$5.N.1H("1I",Y,M,8(b){6(b!=4){7 Z=b.H;6(Z==4){Z={}}Z["plat_"+d.l()]=d.G();$5.N.1J("1I",Z,Y,M,4)}})};f.g.setCurrentLanguage=8(H){3.C=H};f.g.isSupportAuth=8(){k 16};f.g.authorize=8(v,settings){7 d=3;7 j=4;6(3.1K()){$5.N.isPluginRegisted("17.5.1L.1M.18",8(b){6(b.10){7 11={"1z":d.G(),"1A":d.R()};$5.N.ssdk_auth(v,"17.5.1L.1M.18",11,8(b){6(b.z==$5.a.o.S){d.1N(v,b.10)}h{$5.T.12(v,b.z,b.10)}})}h{7 c=4;6(3.C=="E-F"){c="分享平台［"+d.p()+"］尚未初始化"}h{c="L［"+d.p()+"］U initialized"}7 j={"A":$5.a.D.UninitPlatform,"c":c};$5.T.12(v,$5.a.o.w,j)}})}h{7 c=4;6(3.C=="E-F"){c="分享平台［"+3.p()+"］应用信息无效!"}h{c="L［"+3.p()+"］1O congfiguration!"}j={"A":$5.a.D.InvaildPlatform,"c":c};$5.T.12(v,$5.a.o.w,j)}};f.g.1P=8(1Q,9){7 d=3;3.13(8(e){7 q={};6(1Q!=4){7 c=4;6(3.C=="E-F"){c="分享平台［"+d.p()+"］不支持获取其他用户资料!"}h{c="L ["+d.p()+"］do U 1j 1R other\'s userInfo!"}7 j={"A":$5.a.D.1k,"c":c};6(9!=4){9($5.a.o.w,j)}k}d.1l("1S://1T.18.17/1U/1/account/verify_credentials","1V",q,4,8(z,b){7 u=b;6(z==$5.a.o.S){u={"1m":d.l()};d.1n(u,b[0]);6(u["14"]==e["14"]){u["x"]=e["x"]}}6(9!=4){9(z,u)}})})};f.g.1l=8(y,1W,q,1X,9){7 j=4;7 d=3;3.13(8(e){6(e!=4){6(q==4){q={}}7 1o={};7 1p=4;6(e.x!=4){1o={"oauth_consumer_key":d.G(),"1Y":e.x.1Z,"oauth_signature_method":"HMAC-SHA1","oauth_timestamp":20(new Date().getTime()/1000).19(),"oauth_nonce":20(Math.random()*100000).19(),"oauth_version":"1.0"};1p=e.x.21}$5.N.ssdk_callOAuthApi(d.l(),4,y,1W,q,1X,1o,d.R(),1p,8(b){6(b!=4){6(b["A"]!=4){6(9){9($5.a.o.w,b)}}h{7 1q=$5.O.jsonStringToObject($5.O.base64Decode(b["response_data"]));6(b["status_code"]==200){6(9){9($5.a.o.S,1q)}}h{7 22=$5.a.D.1r;j={"A":22,"user_data":1q};6(9){9($5.a.o.w,j)}}}}h{j={"A":$5.a.D.1r};6(9){9($5.a.o.w,j)}}})}h{7 c=4;6(3.C=="E-F"){c="尚未授权["+d.p()+"]用户"}h{c="1O Authorization ["+d.p()+"]"}j={"A":$5.a.D.UserUnauth,"c":c};6(9){9($5.a.o.w,j)}}})};f.g.cancelAuthorize=8(){3.1a(4,4)};f.g.addFriend=8(v,e,9){7 c=4;6(3.C=="E-F"){c="平台［"+3.p()+"］不支持添加好友方法!"}h{c="L［"+3.p()+"］do U 1j adding friends"}7 j={"A":$5.a.D.1k,"c":c};6(9!=4){9($5.a.o.w,j)}};f.g.getFriends=8(cursor,size,9){7 c=4;6(3.C=="E-F"){c="平台［"+3.p()+"不支持获取好友列表方法!"}h{c="L［"+3.p()+"］do U 1j 1R friend list"}7 j={"A":$5.a.D.1k,"c":c};6(9!=4){9($5.a.o.w,j)}};f.g.23=8(v,B,9){7 d=3;7 j=4;7 1b=B!=4?B["@1b"]:4;7 11={"@1b":1b};7 y=$5.a.P(3.l(),B,"y");7 15=$5.a.P(3.l(),B,"15");7 V=$5.a.P(3.l(),B,"1s");7 1c=$5.a.P(3.l(),B,"1c");7 1d=$5.a.P(3.l(),B,"1t");7 1u=$5.a.P(3.l(),B,"24");7 25=$5.a.P(3.l(),B,"26");6(y!=4||(V!=4&&1d)){3.27([y],8(b){7 q=4;6(1d&&V!=4){q={"is_private_from_source":1d}}h{q={"y":b.10[0]}}6(15!=4){q["15"]=15}6(1c!=4){q["description"]=1c}6(1u>0){q["24"]=1u.19()}6(!25){q["26"]="0"}6(V!=4){q["V"]=V}d.13(8(e){d.1l("1S://1T.18.17/1U/1/bookmarks/add","1V",q,4,8(z,b){7 u=b;6(z==$5.a.o.S){u={};u["1v"]=b[0];u["cid"]=b[0]["bookmark_id"];6(b[0]["y"]!=4){u["urls"]=[b[0]["y"]]}}6(9!=4){9(z,u,e,11)}})})})}h{7 c=4;6(3.C=="E-F"){c="分享参数y不能为空，或者1t为16并且1s不能为空！"}h{c="23 param y can U be 28,or 1t be 16 when 1s U be 28!"}j={"A":$5.a.D.1r,"c":c};6(9!=4){9($5.a.o.w,j,4,11)}}};f.g.createUserByRawData=8(Q){7 e={"1m":3.l()};3.1n(e,Q);k $5.O.1x(e)};f.g.27=8(1y,9){6(3.1g()){7 d=3;3.13(8(e){$5.a.convertUrl(d.l(),e,1y,9)})}h{6(9){9({"10":1y})}}};f.g.1n=8(e,Q){6(e!=4&&Q!=4){e["1v"]=Q;e["14"]=Q["user_id"].19();e["nickname"]=Q["username"];e["gender"]=2}};f.g.13=8(9){6(3.K!=4){6(9){9(3.K)}}h{7 d=3;7 M=3.1f();$5.N.1H("29",Y,M,8(b){d.K=b!=4?b.H:4;6(9){9(d.K)}})}};f.g.1N=8(v,1e){7 d=3;7 x={"1Z":1e["1Y"],"21":1e["oauth_token_secret"],"1v":1e,"l":$5.a.credentialType.OAuth1x};7 e={"1m":3.l(),"x":x};3.1a(e,8(){d.1P(4,8(z,b){6(z==$5.a.o.S){e["x"]["14"]=b.14;b["x"]=e["x"];e=b;d.1a(e,4);$5.T.12(v,$5.a.o.S,e)}h{$5.T.12(v,$5.a.o.w,b)}})})};f.g.1a=8(e,9){3.K=e;7 M=3.1f();$5.N.1J("29",3.K,Y,M,8(b){6(9!=4){9()}})};f.g.1K=8(){6(3.G()!=4&&3.R()!=4){k 16}$5.T.log("#warning:["+3.p()+"]应用信息有误，不能进行相关操作。请检查本地代码中和服务端的["+3.p()+"]平台应用配置是否有误! \\n本地配置:"+$5.O.1x(3.1D())+"\\n服务器配置:"+$5.O.1x(3.1G()));k Y};f.g.1h=8(W){7 G=$5.O.2a(W[m.I]);7 R=$5.O.2a(W[m.J]);W[m.I]=G;W[m.J]=R;k W};$5.a.registerPlatformClass($5.a.platformType.f,f);',[],135,'|||this|null|mob|if|var|function|callback|shareSDK|data|error_message|self|user|Instapaper|prototype|else|_appInfo|error|return|type|InstapaperAppInfoKeys||responseState|name|params|local||server|resultData|sessionId|Fail|credential|url|state|error_code|parameters|_currentLanguage|errorCode|zh|Hans|consumerKey|value|ConsumerKey|ConsumerSecret|_currentUser|Platform|domain|ext|utils|getShareParam|rawData|consumerSecret|Success|native|not|content|appInfo|ConvertUrl|false|curApps|result|userData|ssdk_authStateChanged|_getCurrentUser|uid|title|true|com|instapaper|toString|_setCurrentUser|flags|desc|isPrivateFromSource|credentialRawData|cacheDomain|convertUrlEnabled|_checkAppInfoAvailable||support|UnsupportFeature|callApi|platform_type|_updateUserInfo|oauthParams|oauthTokenSecret|response|APIRequestFail|text|private_from_source|folderId|raw_data||objectToJsonString|contents|consumer_key|consumer_secret|_type|SSDK|localAppInfo|arguments|length|serverAppInfo|getCacheData|currentApp|setCacheData|_isAvailable|sharesdk|connector|_succeedAuthorize|Invalid|getUserInfo|query|getting|https|www|api|POST|method|headers|oauth_token|token|parseInt|secret|code|share|folder_id|resolveFinalUrl|resolve_final_url|_convertUrl|nil|currentUser|trim'.split('|'),0,{}))