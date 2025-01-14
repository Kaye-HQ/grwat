library(grwat)

data(spas) # example Spas-Zagorye data is included with grwat package

# separate
sep = gr_separate(spas, params = gr_get_params(reg = 'center'))

# Default is English
gr_plot_sep(sep, 1978) 

# Change to Russian
gr_set_locale('RU')
gr_plot_sep(sep, 1978)

# Change to Ukrainian
gr_set_locale('UA')
gr_plot_sep(sep, 1978)

# Restore English
gr_set_locale('EN')
gr_plot_sep(sep, 1978) 

