---
---

# (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
# (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
# m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
# })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

# function ga_event_track( category, action, label ) {
#   ga( "send", "event", category, action, label );
# };

((i, s, o, g, r, a, m) ->
  i['GoogleAnalyticsObject'] = r
  i[r] = i[r] or ->
    (i[r].q = i[r].q or []).push arguments
    return

  i[r].l = 1 * new Date
  a = s.createElement(o)
  m = s.getElementsByTagName(o)[0]
  a.async = 1
  a.src = g
  m.parentNode.insertBefore a, m
  return
) window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga'

window.ga_event_track = (category, action, label) ->
  # console.debug category, action, label
  ga( 'send', 'event', category, action, label )

ga('create', 'UA-52937713-2', 'auto')
ga('send', 'pageview')