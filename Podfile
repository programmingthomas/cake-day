pod 'AFNetworking'
pod 'FormatterKit'
pod 'FMDB'

prepare_cmd = <<-CMD
    SUPPORTED_LOCALES = "['base', 'en']"
    find . -type d ! -name "*SUPPORTED_LOCALES.lproj" | grep .lproj | xargs rm -rf
CMD
