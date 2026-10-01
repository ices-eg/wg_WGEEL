# add_user.R - run it once per user, then paste the output into credentials.yml
library(sodium)
pwd <- readline("Password: ")
clipr::write_clip(sodium::password_store(pwd))

# paste in credentials