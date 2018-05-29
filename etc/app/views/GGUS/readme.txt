# add user_name/passwords in lavoisier-config.properties
--------------------------------------------------------
GGUS.user_name.test.GGUS_OPS = xxxxxx
GGUS.password.test.GGUS_OPS = xxxxxx
GGUS.user_name.test.GGUS_TEAM = xxxxxx
GGUS.password.test.GGUS_TEAM = xxxxxx
GGUS.user_name.test.CIC_HelpDesk = xxxxxx
GGUS.password.test.CIC_HelpDesk = xxxxxx

GGUS.user_name.prod.GGUS_OPS = xxxxxx
GGUS.password.prod.GGUS_OPS = xxxxxx
GGUS.user_name.prod.GGUS_TEAM = xxxxxx
GGUS.password.prod.GGUS_TEAM = xxxxxx
GGUS.user_name.prod.CIC_HelpDesk = xxxxxx
GGUS.password.prod.CIC_HelpDesk = xxxxxx

# include GGUS configuration file to the global configuration
-------------------------------------------------------------
@INCLUDES=\  GGUS/lavoisier-config.properties

# add keys to hide critical data in lavoisier-hidden-properties.xml
-------------------------------------------------------------------
# keys of the properties to hide

GGUS.user_name.test.GGUS_OPS
GGUS.password.test.GGUS_OPS
GGUS.user_name.test.GGUS_TEAM
GGUS.password.test.GGUS_TEAM
GGUS.user_name.test.CIC_HelpDesk
GGUS.password.test.CIC_HelpDesk

GGUS.user_name.prod.GGUS_OPS
GGUS.password.prod.GGUS_OPS
GGUS.user_name.prod.GGUS_TEAM
GGUS.password.prod.GGUS_TEAM
GGUS.user_name.prod.CIC_HelpDesk
GGUS.password.prod.CIC_HelpDesk

