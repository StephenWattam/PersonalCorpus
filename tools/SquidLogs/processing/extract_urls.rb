#!/usr/bin/env ruby



ACCEPTABLE_TYPES = [/text\/plain/, /text\/xml/, /text\/plain/, /text\/json/, /text\/x?html/i]
BLACKLIST_URL_RX = [/.cur\??$/, /.xml\??$/, /.js\??$/, /.gif\??$/, /ajax.php\??$/, /timedtext\?$/, /.ico$/, /\/assets\/fonts/, /.woff$/,
                    /scorecardresearch.com\/r\?$/, /webautofill\??$/, /doubleclick.net/, /.jpg\??$/, /bbc.co.uk\/iplayer/,
                    /getNotifierData.html\?$/, /check-ajax-add.html$/, /merchbar\/add.html\?$/, /widget\/product-gc\?$/, /twister\/ajaxv2\?$/, /\/gp\/rcxll\/dpview\//,
                    /checksave.php\?$/, /associated\/vulns.html\?/, /spoofer-extension.appspot.com\/update/, /getSegment.php\?$/,
                    /generateHealthyButton\?/, /tweet_button/, /widgets\/hub.html/, /test.png$/, /review\/dynamic/, /s\/ref=/, /widgets\.wp\.com/, 
                    /hostedbadge.php\??$/, /raw\/handlers\/raw.html\??$/, /adjuggler.net/, /xmlProxy.htm\??$/, /ajax.last.fm\/heartbeat$/, /AnswerBarHandler\?$/, 
                    /Passport.aspx\?$/, /\/fd\/fb\//, /GARecord\?$/, /RuleBasedPopunder\?$/, /ActionRecord\?$/, /VideoSessionAjax\?$/, /SavesAjax$/, 
                    /disqus\.com\//, /zoomSess.php\?$/, /zoomLoad.php\?$/, /badge\/badges_json_v2.php\?/, /markdown-help\?$/, /visiblemeasures\.com\/log\?/,
                    /msve\.php\/?$/, /msvp\.php\?$/, /api.flattr.com/, /set_cookie$/, /twitch\.tv\/ad\?$/, /ajax\/popular\/most_popular$/, /uk-ads\.openx\.net/, 
                    /amazon-adsystem\.com/, /burstnet\.com\/bmuk\/display\//, /ad\.yieldmanager\.com/, /adnxs.com\//, /Xaxis_ePrivacy/, /adjug\.com/,
                    /advertising\.com/, /widgets\/follow_button/, /data.hs.php\?$/, /ip.php\?/, /imgur\.com\/include/, /quantcast\.com\/profile\/performance/,
                    /ifr\?$/, /widget\/standard\/height/, /navigation\/flyout\..*\.html/, /badge\.getinfo\?$/, /tribalfusion\.com\//, /nexac\.com/, 
                    /atdmt\.com\//, /invitemedia\.com/, /zedo.com\//, /adsonar\.com\//, /ad_request\?$/, /plugins\/like.php\?$/, /adServer.bs\?$/, 
                    /serving-sys\.com\//, /mookie[0-9]\.com\//, /\.googlesyndication\.com\//, /assets\.tumblr\.com\//, /assets.pinterest.com\//,
                    /admin\.engadget\./, /bcp\.crwdcntrl\.net\//, /share-button\?$/, /rule\.php\?$/, /vop\.sundaysky\.com/, /\/userstatusx2.atc\??$/,
                    /xdrpc\.html\??$/, /bmuk\.burstnet\.com\//, /ad\.360yield\.com\//, /ads\.heias\.com\//, /deviceRedirectList\.json$/,
                    /v\.fwmrm.net\//, /\.feiwei\.tv\//, /tidaltv\.com/, /livepass\.conviva\.com/, /javascript\/blank.html$/, /(static|cookie)\.radioplayer\.co\.uk\//,
                    /www\.bbc\.co\.uk\/.*\.inc$/, /discussion\/p\//, /optimizely\.com\//, /redditmedia\.com\//, /rubiconproject\.com/, /2mdn\.net\/ads\//,
                    /ad\.turn\.com\//, /addthis\.com/, /vi\.raptor\.ebay/, /levexis\.com/, /edgefcs\.net/, /data\.js\.php\?$/, /fcs\/ident2/, 
                    /navbar\.g\?$/, /kontactr\.com/, /related\.php\?$/, /\/idmap\//, /evaluationAjaxService\.htm\?$/, /fetch_promo\?$/, /media_bdbviewer_AR/,
                    /storageframe\.html/
]
ACCEPTABLE_STATUSES = [200]

# See http://wiki.squid-cache.org/Features/LogFormat
RX = /^(?<time>[0-9.]+)\s+(?<elapsed>[0-9]+)\s+(?<remotehost>[\w.:]+)\s+(?<code>[\w]+)\/(?<status>[0-9]+)\s(?<bytes>[0-9]+)\s(?<method>\w+)\s+(?<url>[^\s]+)\s+(?<rfc931>[\w\-]+)\s+(?<peerstatus>\w+)\/(?<peerhost>[\w.:\-]+)\s+(?<type>[\w\/;\-,+.]+)\s*$/

# Load filename of squid logs

fout = STDOUT

# Load unique timestamps only
lines = {}

ARGV.each{|file|


  fin = File.open(file, 'r') if file && File.exist?(file)




  last = nil
  tlast = nil
  fin.each_line do |line|
    
    if(m = line.match(RX))
      if ACCEPTABLE_TYPES.map { |trx| m[:type] =~ trx }.inject(false){|a, b| a or b}
        unless BLACKLIST_URL_RX.map { |trx| m[:url] =~ trx }.inject(false){|a, b| a or b}
          if ACCEPTABLE_STATUSES.include?(m[:status].to_i)
            if m[:url] != last
              last = m[:url]
              time = Time.at(m[:time].to_f)

              # puts "line: '#{line}'"
              # puts "time: #{m[:time]} #{time}"
              # puts "elapsed: #{m[:elapsed]}"
              # puts "remote: #{m[:remotehost]}"
              # puts "code: #{m[:code]}"
              # puts "status: #{m[:status]}"
              # puts "bytes: #{m[:bytes]}"
              # puts "method: #{m[:method]}"
              # puts "url: #{m[:url]}"
              # puts "rfc391: #{m[:rfc391]}"
              # puts "peerstatus: #{m[:peerstatus]}"
              # puts "peerhost: #{m[:peerhost]}"
              # puts "type: #{m[:type]}"
              #
              
              tdiff = m[:time].to_f - tlast if tlast
              lines[m[:time]] = "#{m[:time]} #{tdiff} #{time} #{m[:rfc931]} #{m[:url]}\n"

              tlast = m[:time].to_f
            else
              # puts "No change: #{line}"
            end
          else
            # puts "Wrong status: #{line}"
          end
        else
          # puts "Failed blacklist: #{line}"
        end
      else
        # puts "Wrong type: #{line}"
      end
    else
      # puts "Wrong format: #{line}"
    end



  end

}


# puts "loaded #{lines.length} unique entries"

fout.write("utime tdiff date time zone auth url\n")
lines.each{|time, line|
  fout.write(line)
}
