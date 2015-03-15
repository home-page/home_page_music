if Setting.table_exists?
  Setting['home_page.general.navigation.items'] = [['music', 'music'], 'users', 'settings', 'authentication']
end