# HELPERS

# Test if variable % is set or exit with error.
isset-%: 
	@: $(if $(value $*),,$(error Variable $* is not set))