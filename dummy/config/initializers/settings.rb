if Setting.table_exists?
  Setting['home_page.general.navigation.items'] = [['music', 'music'], 'page_modules', 'users', 'settings', 'authentication']
end