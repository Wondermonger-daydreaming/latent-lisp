from abc import ABC, abstractmethod


class Provider(ABC):
    network_capable = False

    @abstractmethod
    def emit(self, request, prompt_bytes):
        raise NotImplementedError
