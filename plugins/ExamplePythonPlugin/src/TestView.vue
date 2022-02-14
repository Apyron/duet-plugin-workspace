<template>
	<v-simple-table>
		<template #default>
			<v-btn class="mr-3" color="info" @click="onButtonPress">
				Test Python request
			</v-btn>
		</template>
	</v-simple-table>
</template>

<script>
'use strict'

const axios = require("axios");

export default {
	methods: {
		async onButtonPress() {
			try {
				let reply = await axios.get("/machine/TestPython/RandomInt");
				alert('Got random reply: ' + reply);
			} catch (error) {
				alert('Got error: ' + error.message);
				console.error('test python error', error);
			}
		}
	}
}
</script>
