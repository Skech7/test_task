module HelperMethods
  def navigate_to(ui_sref)
    puts "Navigate_to action helper called."
    browser.link('ui-sref': ui_sref).click
  end

  def hash_data(opts = {})
    opts
  end
end
