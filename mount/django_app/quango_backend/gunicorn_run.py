
from uvicorn.workers import UvicornWorker

class MyUvicornWorker(UvicornWorker):
	
	CONFIG_KWARGS = {
		# Django (for now) does not support ASGI Lifespan, so explicitly disable to quiet warnings
		"lifespan": "off", 
		"forwarded_allow_ips": "*", 
		"proxy_headers": True, 
	}
