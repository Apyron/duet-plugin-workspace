import re
import sys

def list_plugin_args(plugins: [str]) -> str:
    plugin_to_add = """
        new DwcPlugin({
            id: '{plugin_name}',
            name: '{plugin_name}',
            author: 'PluginPatcher',
            version,
            loadDwcResources: () => import(
                /* webpackChunkName: "{plugin_name}" */
                './{plugin_name}/src/index.js'
            )
        }),
    """
    result = []
    for plugin in plugins:
        result.append(plugin_to_add.replace("{plugin_name}", plugin))
    return "\n".join(result) 

with open(sys.argv[1]) as f:
    result = re.sub(r"(\/\/ Add your own plugins here during development....)+?(\])", r"\1" + list_plugin_args(sys.argv[3:]) +  r"\2", f.read(), flags=re.S)
with open(sys.argv[2], 'w') as f:
    f.write(result)