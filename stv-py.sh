#!/bin/bash

#获取目录
CURRENT_DIR=$(cd $(dirname $0); pwd)
num=$(find $CURRENT_DIR -name gradlew  | awk -F"/" '{print NF-1}')
DIR=$(find $CURRENT_DIR -name gradlew  | cut -d \/ -f$num)
cd $CURRENT_DIR/$DIR
#共存
sed -i 's/com.github.tvbox.osc/com.tv.stv.py/g' $CURRENT_DIR/$DIR/app/build.gradle
#sed -i 's/com.github.tvbox.stv/com.tv.stv/g' $CURRENT_DIR/$DIR/app/build.gradle
#签名
signingConfigs='ICAgIHNpZ25pbmdDb25maWdzIHtcCiAgICAgICAgaWYgKHByb2plY3QuaGFzUHJvcGVydHkoIlJFTEVBU0VfU1RPUkVfRklMRSIpKSB7XAogICAgICAgICAgICBteUNvbmZpZyB7XAogICAgICAgICAgICAgICAgc3RvcmVGaWxlIGZpbGUoUkVMRUFTRV9TVE9SRV9GSUxFKVwKICAgICAgICAgICAgICAgIHN0b3JlUGFzc3dvcmQgUkVMRUFTRV9TVE9SRV9QQVNTV09SRFwKICAgICAgICAgICAgICAgIGtleUFsaWFzIFJFTEVBU0VfS0VZX0FMSUFTXAogICAgICAgICAgICAgICAga2V5UGFzc3dvcmQgUkVMRUFTRV9LRVlfUEFTU1dPUkRcCiAgICAgICAgICAgICAgICB2MVNpZ25pbmdFbmFibGVkIHRydWVcCiAgICAgICAgICAgICAgICB2MlNpZ25pbmdFbmFibGVkIHRydWVcCiAgICAgICAgICAgICAgICBlbmFibGVWM1NpZ25pbmcgPSB0cnVlXAogICAgICAgICAgICAgICAgZW5hYmxlVjRTaWduaW5nID0gdHJ1ZVwKICAgICAgICAgICAgfVwKICAgICAgICB9XAogICAgfVwKXA=='
signingConfig='ICAgICAgICAgICAgaWYgKHByb2plY3QuaGFzUHJvcGVydHkoIlJFTEVBU0VfU1RPUkVfRklMRSIpKSB7XAogICAgICAgICAgICAgICAgc2lnbmluZ0NvbmZpZyBzaWduaW5nQ29uZmlncy5teUNvbmZpZ1wKICAgICAgICAgICAgfVwK'
signingConfigs="$(echo "$signingConfigs" |base64 -d )"
signingConfig="$(echo "$signingConfig" |base64 -d )"
sed -i -e "/defaultConfig {/i\\$signingConfigs " -e "/debug {/a\\$signingConfig " -e "/release {/a\\$signingConfig " $CURRENT_DIR/$DIR/app/build.gradle
cp -f $CURRENT_DIR/DIY/TVBoxOSC.jks $CURRENT_DIR/$DIR/app/TVBoxOSC.jks
cp -f $CURRENT_DIR/DIY/TVBoxOSC.jks $CURRENT_DIR/$DIR/TVBoxOSC.jks
echo "" >>$CURRENT_DIR/$DIR/gradle.properties
echo "RELEASE_STORE_FILE=./TVBoxOSC.jks" >>$CURRENT_DIR/$DIR/gradle.properties
echo "RELEASE_KEY_ALIAS=tvbox" >>$CURRENT_DIR/$DIR/gradle.properties
echo "RELEASE_STORE_PASSWORD=12348765" >>$CURRENT_DIR/$DIR/gradle.properties
echo "RELEASE_KEY_PASSWORD=12348765" >>$CURRENT_DIR/$DIR/gradle.properties
#xwalk修复
#sed -i 's/download.01.org\/crosswalk\/releases\/crosswalk\/android\/maven2/raw.githubusercontent.com\/lm317379829\/TVBoxDIY\/main/g' $CURRENT_DIR/$DIR/build.gradle
#名称修改
sed -i 's/TVBox/STV-PY版/g' $CURRENT_DIR/$DIR/app/src/main/res/values/strings.xml
#内置接口
sed -i 's|API_URL, ""|API_URL, "http://lytv.cf/mtv"|g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
#修改远程管理首页名
sed -i 's/TVBox/STV/g' $CURRENT_DIR/$DIR/app/src/main/res/raw/index.html
#修改视频播放页操作栏
sed -i 's/播放/ /g' $CURRENT_DIR/$DIR/app/src/main/res/layout/player_vod_control_view.xml
sed -i 's/上一集/上集/g' $CURRENT_DIR/$DIR/app/src/main/res/layout/player_vod_control_view.xml
sed -i 's/下一集/下集/g' $CURRENT_DIR/$DIR/app/src/main/res/layout/player_vod_control_view.xml
sed -i 's/片头片尾/片头尾/g' $CURRENT_DIR/$DIR/app/src/main/res/layout/player_vod_control_view.xml
#修改时钟显示
sed -i 's|SimpleDateFormat("HH:mm:ss")|SimpleDateFormat("yyyy年MM月dd日 EE HH:mm:ss")|g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/LivePlayActivity.java #直播
sed -i 's|yyyy/MM/dd HH:mm|yyyy年MM月dd日 EE HH:mm:ss|g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/HomeActivity.java  #首页
#sed -i 's|SimpleDateFormat("HH:mm:ss")|SimpleDateFormat("yyyy年MM月dd日 EE HH:mm:ss")|g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/player/controller/VodController.java  #视频
#图标修改
cp $CURRENT_DIR/DIY/app_icon.png $CURRENT_DIR/$DIR/app/src/main/res/drawable-hdpi/app_icon.png
cp $CURRENT_DIR/DIY/app_icon.png $CURRENT_DIR/$DIR/app/src/main/res/drawable-xhdpi/app_icon.png
cp $CURRENT_DIR/DIY/app_icon.png $CURRENT_DIR/$DIR/app/src/main/res/drawable-xxhdpi/app_icon.png
mv $CURRENT_DIR/DIY/app_icon.png $CURRENT_DIR/$DIR/app/src/main/res/drawable-xxxhdpi/app_icon.png
#背景修改
#mv $CURRENT_DIR/DIY/app_bg.png $CURRENT_DIR/$DIR/app/src/main/res/drawable/app_bg.png
#取消选集全屏
#sed -i 's/if (showPreview \&\& !fullWindows) toggleFullPreview/\/\/if (showPreview \&\& !fullWindows) toggleFullPreview/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/DetailActivity.java
#缩略图清晰度修改
#sed -i 's/mContext, 400/mContext, 500/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/DetailActivity.java
#sed -i 's/mContext, 300/mContext, 400/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/DetailActivity.java
#sed -i 's/mContext, 400/mContext, 500/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/GridAdapter.java
#sed -i 's/mContext, 300/mContext, 400/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/GridAdapter.java
#sed -i 's/mContext, 400/mContext, 500/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/HistoryAdapter.java
#sed -i 's/mContext, 300/mContext, 400/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/HistoryAdapter.java
#添加PY支持
wget --no-check-certificate -qO- "https://raw.githubusercontent.com/UndCover/PyramidStore/main/aar/pyramid-1011.aar" -O $CURRENT_DIR/$DIR/app/libs/pyramid.aar
sed -i "/thunder.jar/a\    implementation files('libs@pyramid.aar')" $CURRENT_DIR/$DIR/app/build.gradle
sed -i 's#@#\\#g' $CURRENT_DIR/$DIR/app/build.gradle
sed -i 's#pyramid#\\pyramid#g' $CURRENT_DIR/$DIR/app/build.gradle
echo "" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "#添加PY支持" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-keep public class com.undcover.freedom.pyramid.** { *; }" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-dontwarn com.undcover.freedom.pyramid.**" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-keep public class com.chaquo.python.** { *; }" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-dontwarn com.chaquo.python.**" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
sed -i '/import com.orhanobut.hawk.Hawk;/a\import com.undcover.freedom.pyramid.PythonLoader;' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/import com.orhanobut.hawk.Hawk;/a\import com.github.catvod.crawler.SpiderNull;' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/PlayerHelper.init/a\        PythonLoader.getInstance().setApplication(this);' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/import android.util.Base64;/a\import com.github.catvod.crawler.SpiderNull;' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/import android.util.Base64;/a\import com.undcover.freedom.pyramid.PythonLoader;' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/private void parseJson(String apiUrl, String jsonStr)/a\        PythonLoader.getInstance().setConfig(jsonStr);' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/public Spider getCSP(SourceBean sourceBean)/a\        if (sourceBean.getApi().startsWith(\"py_\")) {\n        try {\n            return PythonLoader.getInstance().getSpider(sourceBean.getKey(), sourceBean.getExt());\n        } catch (Exception e) {\n            e.printStackTrace();\n            return new SpiderNull();\n        }\n    }' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/public Object\[\] proxyLoca/a\    try {\n        if(param.containsKey(\"api\")){\n            String doStr = param.get(\"do\").toString();\n            if(doStr.equals(\"ck\"))\n                return PythonLoader.getInstance().proxyLocal(\"\",\"\",param);\n            SourceBean sourceBean = ApiConfig.get().getSource(doStr);\n            return PythonLoader.getInstance().proxyLocal(sourceBean.getKey(),sourceBean.getExt(),param);\n        }else{\n            String doStr = param.get(\"do\").toString();\n            if(doStr.equals(\"live\")) return PythonLoader.getInstance().proxyLocal(\"\",\"\",param);\n        }\n    } catch (Exception e) {\n        e.printStackTrace();\n    }\n' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
#FongMi的jar支持
echo "" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-keep class com.google.gson.**{*;}" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro

echo 'DIY end'
