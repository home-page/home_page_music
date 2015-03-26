if Setting.table_exists?
  Setting['home_page.general.navigation.items'] = [['music', 'music'], 'pages', 'users', 'settings', 'authentication']
end