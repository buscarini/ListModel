Pod::Spec.new do |s|
  s.name         = "ListModel"
  s.version      = "0.4.3"
  s.summary      = "View Models to simplify using tables, collection views"
  s.description  = <<-DESC
    Your description here.
  DESC
  s.homepage     = "https://github.com/buscarini/listmodel"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "José Manuel Sánchez" => "buscarini@gmail.com" }
  s.social_media_url   = ""
  
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"
  
  s.source       = { :git => "https://github.com/buscarini/listmodel.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "UIKit"
end
