pod 'FMDB'
pod 'ChameleonFramework'
pod 'AFNetworking'
pod 'FormatterKit'

prepare_cmd = <<-CMD
    SUPPORTED_LOCALES = "['base', 'en']"
    find . -type d ! -name "*SUPPORTED_LOCALES.lproj" | grep .lproj | xargs rm -rf
CMD
