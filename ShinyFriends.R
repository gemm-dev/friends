library(shiny)
library(shinythemes)

rsconnect::setAccountInfo(name='<NAME>',
                          token='<TOKEN>',
                          secret='<SECRET>') #replace this with your info

ui = shinyUI(fluidPage(
                       tags$head(
                         HTML('<title>Which Friends Character Are You?</title>'),
                       tags$style(HTML("
                                         @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                                         
                                         h1,h2,h3 {
                                         font-family: 'Lobster', cursive;
                                         font-weight: 500;
                                         line-height: 1.1;
                                         color: red;
                                         text-align:left;
                                         }

                                        #main{
                                        float:left;
                                        }
                                        body{
                                        background-color:silver;
                                       }
                                         
                                         "))
),




headerPanel(h1('Which Friends Character Are You?')),

HTML('<br><img src="https://img.maximummedia.ie/her_ie/eyJkYXRhIjoie1widXJsXCI6XCJodHRwOlxcXC9cXFwvbWVkaWEtaGVyLm1heGltdW1tZWRpYS5pZS5zMy5hbWF6b25hd3MuY29tXFxcL3dwLWNvbnRlbnRcXFwvdXBsb2Fkc1xcXC8yMDE4XFxcLzAxXFxcLzAxMTcxNTM0XFxcL2ZyaWVuZHMxLmpwZ1wiLFwid2lkdGhcIjo3NjcsXCJoZWlnaHRcIjo0MzEsXCJkZWZhdWx0XCI6XCJodHRwczpcXFwvXFxcL3d3dy5oZXIuaWVcXFwvYXNzZXRzXFxcL2ltYWdlc1xcXC9oZXJcXFwvbm8taW1hZ2UucG5nP3Y9NVwifSIsImhhc2giOiI2ZWNmMWU5ZTdkMTJmYWU3YWJiOTk2MjliNDMyZjJlMTZjNmZhN2E3In0=/friends1.jpg" height="300" style="float:none; margin: 0 auto;"><br><br>'),

mainPanel(
  id = "main",
  textInput("link", "Paste link to your image here:", 
            value="https://redditupvoted.files.wordpress.com/2015/10/ross-gellernew.jpg?w=1200&h=580&crop=1"),
  actionButton(inputId = "submit_img", label = "Submit (and be patient!)"),
  h2("You are:", textOutput("result1")),
  h3("Confidence:", textOutput("result2")),
  HTML('<br><br>'),
  p("Make sure you are linking only to an image, not an entire web page. 
    Results should take around 5-10 seconds to appear, unless the API transactions/minute limit has been reached. 
    Contact gshay@wesleyan.edu for more info."), HTML('<a href="https://github.com/gemm-dev/friends">Source Code</a>')
)))


server = shinyServer(function(input, output) {
  
  observeEvent(
    eventExpr = input[["submit_img"]],
    handlerExpr = {
      print("PRESSED")
      
      library(httr)
      app_id = "72fe429c"
      app_key = "f0d7a072cbb212451e2dc5a98a19c7a2"
      detect_endpoint = "https://api.kairos.com/detect"
      gal_endpoint="https://api.kairos.com/gallery/view"
      enroll_endpoint="https://api.kairos.com/enroll"
      recognize_endpoint="https://api.kairos.com/recognize"
      rem_gal="https://api.kairos.com/gallery/remove"
      
      jsonlink=isolate(input$link)
      
      json_str_1_1 = '{"image": "'
      json_str_1_2 = '"", "subject_id":"User", "gallery_name":"gal", 
                  "threshold":"0.1"}'
      json_str_1 = paste('{ "image":"',jsonlink,'", "subject_id":"User", 
                     "gallery_name":"gal", "threshold":"0.1"}')
      
      json_string_2 = '{ "image":"https://redditupvoted.files.wordpress.com/2015/10/ross-gellernew.jpg?w=1200&h=580&crop=1", "subject_id":"User", "gallery_name":"gal", "threshold":"0.3"}'
      json_string_Ross = '{ "image": "https://www.prolog.rs/upload/article/17546_david%20schwimmer.jpg", "subject_id":"Ross", "gallery_name":"gal"}'
      json_string_Chandler = '{ "image": "http://cimg.tvgcdn.net/i/2017/04/02/234bdf6a-e87a-41a8-94bf-07842011771d/6fc025cc00bfde6457f73440be21108a/chandler-friends-hp-lg.jpg", "subject_id":"Chandler", "gallery_name":"gal"}'
      json_string_Joey = '{ "image": "https://imgix.bustle.com/uploads/image/2017/8/22/4dbabff7-c8bd-4817-abff-a413fd946e49-joey-tribbiani-pineapple.jpg?w=970&h=582&fit=crop&crop=faces&auto=format&q=70", "subject_id":"Joey", "gallery_name":"gal"}'
      json_string_Monica = '{ "image": "https://image.afcdn.com/story/20140225/monica-gellar-184436_w767h767c1cx345cy200.jpg", "subject_id":"Monica", "gallery_name":"gal"}'
      json_string_Rachel = '{ "image": "https://img.maximummedia.ie/her_ie/eyJkYXRhIjoie1widXJsXCI6XCJodHRwOlxcXC9cXFwvbWVkaWEtaGVyLm1heGltdW1tZWRpYS5pZS5zMy5hbWF6b25hd3MuY29tXFxcL3dwLWNvbnRlbnRcXFwvdXBsb2Fkc1xcXC8yMDE3XFxcLzA4XFxcLzI0MTMwMTM1XFxcL1NjcmVlbi1TaG90LTIwMTctMDgtMjQtYXQtMTMuMDAuNTktMTAyNHg1ODkucG5nXCIsXCJ3aWR0aFwiOjc2NyxcImhlaWdodFwiOjQzMSxcImRlZmF1bHRcIjpcImh0dHBzOlxcXC9cXFwvd3d3Lmhlci5pZVxcXC9hc3NldHNcXFwvaW1hZ2VzXFxcL2hlclxcXC9uby1pbWFnZS5wbmc_dj01XCJ9IiwiaGFzaCI6IjRiNjM4NjNlYzIwZTQxNWFiNWNiNDE2NDNjNzZmMjgwZDYyY2QxMjEifQ==/screen-shot-2017-08-24-at-13-00-59-1024x589.png", "subject_id":"Rachel", "gallery_name":"gal"}'
      json_string_Phoebe = '{ "image": "http://static-37.sinclairstoryline.com/resources/media/45fc0172-902f-4f66-a538-c87ed7f96c44-wenn2710740.jpg", "subject_id":"Phoebe", "gallery_name":"gal"}'
      
      POST(url=rem_gal, 
           add_headers("app_id"= app_id,
                       "app_key"=app_key),
           content_type="application/json",
           body= '{"gallery_name":"gal"}')
      
      POST(url=enroll_endpoint, 
           add_headers("app_id"= app_id,
                       "app_key"=app_key),
           content_type="application/json",
           body=json_string_Ross) 
      POST(url=enroll_endpoint, 
           add_headers("app_id"= app_id,
                       "app_key"=app_key),
           content_type="application/json",
           body=json_string_Chandler)
      POST(url=enroll_endpoint, 
           add_headers("app_id"= app_id,
                       "app_key"=app_key),
           content_type="application/json",
           body=json_string_Joey)
      POST(url=enroll_endpoint, 
           add_headers("app_id"= app_id,
                       "app_key"=app_key),
           content_type="application/json",
           body=json_string_Monica)
      POST(url=enroll_endpoint, 
           add_headers("app_id"= app_id,
                       "app_key"=app_key),
           content_type="application/json",
           body=json_string_Rachel)
      POST(url=enroll_endpoint, 
           add_headers("app_id"= app_id,
                       "app_key"=app_key),
           content_type="application/json",
           body=json_string_Phoebe)
      
      
      rec = POST(url=recognize_endpoint,
                 add_headers("app_id"= app_id,
                             "app_key"=app_key),
                 content_type="application/json",
                 body=json_str_1)
      
      c_4=content(rec, as="parsed")
      str(c_4)
      
      friend=reactive(c_4$images[[1]]$transaction$subject_id)
      confidence=reactive(c_4$images[[1]]$transaction$confidence)
      
      output$result1 <- renderText({friend()})
      output$result2 <- renderText({confidence()})
      
    })})

shinyApp(ui=ui, server=server)
